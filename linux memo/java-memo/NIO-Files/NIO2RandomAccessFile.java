package com.mime;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.channels.SeekableByteChannel;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.EnumSet;
import java.util.Set;

public class NIO2RandomAccessFile {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Path path = Paths.get("/tmp", "story.txt");

		// create the custom permissions attribute for the email.txt file
		Set<PosixFilePermission> perms = PosixFilePermissions
				.fromString("rw-r------");
		FileAttribute<Set<PosixFilePermission>> attr = PosixFilePermissions
				.asFileAttribute(perms);

		// write a file using SeekableByteChannel
		try (SeekableByteChannel seekableByteChannel = Files.newByteChannel(
				path, EnumSet.of(StandardOpenOption.WRITE,
						StandardOpenOption.TRUNCATE_EXISTING), attr)) {
			ByteBuffer buffer = ByteBuffer
					.wrap("Rafa Nadal produced another masterclass of clay-court tennis to win his fifth French Open title ..."
							.getBytes());
			int write = seekableByteChannel.write(buffer);
			System.out.println("Number of written bytes: " + write);
			buffer.clear();
		} catch (IOException ex) {
			System.err.println(ex);
		}

		// read a file using SeekableByteChannel
		try (SeekableByteChannel seekableByteChannel = Files.newByteChannel(
				path, EnumSet.of(StandardOpenOption.READ), attr)) {
			ByteBuffer buffer = ByteBuffer.allocate(12);
			String encoding = System.getProperty("file.encoding");
			buffer.clear();
			//随机访问定位API
//			seekableByteChannel.position();
//			seekableByteChannel.truncate(100);
			while (seekableByteChannel.read(buffer) > 0) {
				buffer.flip();
				System.out.print(Charset.forName(encoding).decode(buffer));
				buffer.clear();
			}

			// seekableByteChannel.position(seekableByteChannel.size()/2);

		} catch (IOException ex) {
			System.err.println(ex);
		}

		MappedByteBuffer buffer = null;
		try (FileChannel fileChannel = (FileChannel.open(path,
				EnumSet.of(StandardOpenOption.READ)))) {
			//文件锁
			FileLock lock = fileChannel.lock();
			buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, 0,
					fileChannel.size());
			//文件channel操作，从一个channel通道把数据传输到另外一个channel
//			fileChannel_from.transferTo(0L, fileChannel_from.size(), fileChannel_to);
			lock.release();
		} catch (IOException ex) {
			System.err.println(ex);
		}
		if (buffer != null) {
			try {
				Charset charset = Charset.defaultCharset();
				CharsetDecoder decoder = charset.newDecoder();
				CharBuffer charBuffer = decoder.decode(buffer);
				String content = charBuffer.toString();
				System.out.println(content);
				buffer.clear();
			} catch (CharacterCodingException ex) {
				System.err.println(ex);
			}
		}
	}
}
