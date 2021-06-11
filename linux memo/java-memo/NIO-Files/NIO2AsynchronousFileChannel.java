// 异步channel API
// 
// 主要引入三个异步类: AsynchronousFileChannel,AsynchronousSocketChannel, and AsynchronousServerSocketChannel.
// AsynchronousFileChannel跟FileChannel区别：不保存全局的position和offset，可以制定访问位置，也支持并发访问文件不同。
// AsynchronousServerSocketChannel AsynchronousSocketChannel：能够绑定到一个制定线程池的组中，这个线程池能够用future或者CompletionHandler来对执行结果进行处理，
// AsynchronousChannelGroup：执行异步IO的java线程池的组类，
// AsynchronousChannelGroup.java:
// public static AsynchronousChannelGroup withFixedThreadPool(int nThreads, ThreadFactory threadFactory)
// public static AsynchronousChannelGroup withCachedThreadPool(ExecutorService executor,int initialSize)
// public static AsynchronousChannelGroup withThreadPool(ExecutorService executor)???



package com.mime;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.StandardSocketOptions;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousChannelGroup;
import java.nio.channels.AsynchronousFileChannel;
import java.nio.channels.AsynchronousServerSocketChannel;
import java.nio.channels.AsynchronousSocketChannel;
import java.nio.channels.CompletionHandler;
import java.nio.channels.FileLock;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadLocalRandom;

public class NIO2AsynchronousFileChannel {
	public static void main(String[] args) {
		
		asyFile();
		asyFileChannel2();
		asyServerSocketChannel();
	}

	// 异步文件读写示例
	public static void asyFile() {
		ByteBuffer buffer = ByteBuffer.allocate(100);
		String encoding = System.getProperty("file.encoding");
		Path path = Paths.get("/tmp", "store.txt");
		try (AsynchronousFileChannel asynchronousFileChannel = AsynchronousFileChannel
				.open(path, StandardOpenOption.READ)) {
			Future<Integer> result = asynchronousFileChannel.read(buffer, 0);
			// 读超时控制
			// int count = result.get(100, TimeUnit.NANOSECONDS);

			while (!result.isDone()) {
				System.out.println("Do something else while reading ...");
			}
			System.out.println("Read done: " + result.isDone());
			System.out.println("Bytes read: " + result.get());

			// 使用CompletionHandler回调接口异步读取文件
			final Thread current = Thread.currentThread();
			asynchronousFileChannel.read(buffer, 0,
					"Read operation status ...",
					new CompletionHandler<Integer, Object>() {
						@Override
						public void completed(Integer result, Object attachment) {
							System.out.println(attachment);
							System.out.print("Read bytes: " + result);
							current.interrupt();
						}

						@Override
						public void failed(Throwable exc, Object attachment) {
							System.out.println(attachment);
							System.out.println("Error:" + exc);
							current.interrupt();
						}
					});

		} catch (Exception ex) {
			System.err.println(ex);
		}
		buffer.flip();
		System.out.print(Charset.forName(encoding).decode(buffer));
		buffer.clear();

		// 异步文件写示例
		ByteBuffer buffer1 = ByteBuffer
				.wrap("The win keeps Nadal at the top of the heap in men's"
						.getBytes());
		Path path1 = Paths.get("/tmp", "store.txt");
		try (AsynchronousFileChannel asynchronousFileChannel = AsynchronousFileChannel
				.open(path1, StandardOpenOption.WRITE)) {
			Future<Integer> result = asynchronousFileChannel
					.write(buffer1, 100);
			while (!result.isDone()) {
				System.out.println("Do something else while writing ...");
			}
			System.out.println("Written done: " + result.isDone());
			System.out.println("Bytes written: " + result.get());

			// file lock
			Future<FileLock> featureLock = asynchronousFileChannel.lock();
			System.out.println("Waiting for the file to be locked ...");
			FileLock lock = featureLock.get();
			if (lock.isValid()) {
				Future<Integer> featureWrite = asynchronousFileChannel.write(
						buffer, 0);
				System.out.println("Waiting for the bytes to be written ...");
				int written = featureWrite.get();
				// or, use shortcut
				// int written = asynchronousFileChannel.write(buffer,0).get();
				System.out.println("I’ve written " + written + " bytes into "
						+ path.getFileName() + " locked file!");
				lock.release();
			}

			// asynchronousFileChannel.lock("Lock operation status:", new
			// CompletionHandler<FileLock, Object>() ;

		} catch (Exception ex) {
			System.err.println(ex);
		}
	}

	// public static AsynchronousFileChannel open(Path file, Set<? extends
	// OpenOption> options,ExecutorService executor, FileAttribute<?>... attrs)
	// throws IOException
	private static Set withOptions() {
		final Set options = new TreeSet<>();
		options.add(StandardOpenOption.READ);
		return options;
	}

	// 使用AsynchronousFileChannel.open(path, withOptions(),
	// taskExecutor))这个API对异步文件IO的处理
	public static void asyFileChannel2() {
		final int THREADS = 5;
		ExecutorService taskExecutor = Executors.newFixedThreadPool(THREADS);
		String encoding = System.getProperty("file.encoding");
		List<Future<ByteBuffer>> list = new ArrayList<>();
		int sheeps = 0;
		Path path = Paths.get("/tmp",
				"store.txt");
		try (AsynchronousFileChannel asynchronousFileChannel = AsynchronousFileChannel
				.open(path, withOptions(), taskExecutor)) {
			for (int i = 0; i < 50; i++) {
				Callable<ByteBuffer> worker = new Callable<ByteBuffer>() {
					@Override
					public ByteBuffer call() throws Exception {
						ByteBuffer buffer = ByteBuffer
								.allocateDirect(ThreadLocalRandom.current()
										.nextInt(100, 200));
						asynchronousFileChannel.read(buffer, ThreadLocalRandom
								.current().nextInt(0, 100));
						return buffer;
					}
				};
				Future<ByteBuffer> future = taskExecutor.submit(worker);
				list.add(future);
			}
			// this will make the executor accept no new threads
			// and finish all existing threads in the queue
			taskExecutor.shutdown();
			// wait until all threads are finished
			while (!taskExecutor.isTerminated()) {
				// do something else while the buffers are prepared
				System.out
						.println("Counting sheep while filling up some buffers!So far I counted: "
								+ (sheeps += 1));
			}
			System.out.println("\nDone! Here are the buffers:\n");
			for (Future<ByteBuffer> future : list) {
				ByteBuffer buffer = future.get();
				System.out.println("\n\n" + buffer);
				System.out
						.println("______________________________________________________");
				buffer.flip();
				System.out.print(Charset.forName(encoding).decode(buffer));
				buffer.clear();
			}
		} catch (Exception ex) {
			System.err.println(ex);
		}
	}

	//异步server socket channel io处理示例
	public static void asyServerSocketChannel() {
		
		//使用threadGroup
//		AsynchronousChannelGroup threadGroup = null;
//		ExecutorService executorService = Executors
//		.newCachedThreadPool(Executors.defaultThreadFactory());
//		try {
//		threadGroup = AsynchronousChannelGroup.withCachedThreadPool(executorService, 1);
//		} catch (IOException ex) {
//		System.err.println(ex);
//		}
//		AsynchronousServerSocketChannel asynchronousServerSocketChannel =
//				AsynchronousServerSocketChannel.open(threadGroup);
		
		final int DEFAULT_PORT = 5555;
		final String IP = "127.0.0.1";
		ExecutorService taskExecutor = Executors.newCachedThreadPool(Executors
				.defaultThreadFactory());
		// create asynchronous server socket channel bound to the default group
		try (AsynchronousServerSocketChannel asynchronousServerSocketChannel = AsynchronousServerSocketChannel
				.open()) {
			if (asynchronousServerSocketChannel.isOpen()) {
				// set some options
				asynchronousServerSocketChannel.setOption(
						StandardSocketOptions.SO_RCVBUF, 4 * 1024);
				asynchronousServerSocketChannel.setOption(
						StandardSocketOptions.SO_REUSEADDR, true);
				// bind the server socket channel to local address
				asynchronousServerSocketChannel.bind(new InetSocketAddress(IP,
						DEFAULT_PORT));
				// display a waiting message while ... waiting clients
				System.out.println("Waiting for connections ...");
				while (true) {
					Future<AsynchronousSocketChannel> asynchronousSocketChannelFuture = asynchronousServerSocketChannel.accept();
					//使用CompletionHandler来处理IO事件
//					asynchronousServerSocketChannel.accept(null, new CompletionHandler<AsynchronousSocketChannel, Void>() 
					//client使用CompletionHandler来处理IO事件
					//asynchronousSocketChannel.connect(new InetSocketAddress(IP, DEFAULT_PORT), null,new CompletionHandler<Void, Void>() 
					try {
						final AsynchronousSocketChannel asynchronousSocketChannel = asynchronousSocketChannelFuture
								.get();
						Callable<String> worker = new Callable<String>() {
							@Override
							public String call() throws Exception {
								String host = asynchronousSocketChannel
										.getRemoteAddress().toString();
								System.out.println("Incoming connection from: "
										+ host);
								final ByteBuffer buffer = ByteBuffer
										.allocateDirect(1024);
								// transmitting data
								while (asynchronousSocketChannel.read(buffer)
										.get() != -1) {
									buffer.flip();
								}
								asynchronousSocketChannel.write(buffer).get();
								if (buffer.hasRemaining()) {
									buffer.compact();
								} else {
									buffer.clear();
								}
								asynchronousSocketChannel.close();
								System.out.println(host
										+ " was successfully served!");
								return host;
							}
						};
						taskExecutor.submit(worker);
					} catch (InterruptedException | ExecutionException ex) {
						System.err.println(ex);
						System.err.println("\n Server is shutting down ...");
						// this will make the executor accept no new threads
						// and finish all existing threads in the queue
						taskExecutor.shutdown();
						// wait until all threads are finished
						while (!taskExecutor.isTerminated()) {
						}
						break;
					}
				}
			} else {
				System.out
						.println("The asynchronous server-socket channel cannot be opened!");
			}
		} catch (IOException ex) {
			System.err.println(ex);
		}

	}
}