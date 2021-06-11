
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.List;
import java.util.Set;

public class NIO2FileAndDir {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Path path = FileSystems.getDefault().getPath(
				System.getProperty("user.home"), "www", "pyweb.settings");
		// 检查文件是否存在 exist, not exist, or unknown.
		// !Files.exists(...) is not equivalent to Files.notExists(...) and the
		// notExists() method is not a complement of the exists() method
		// 如果应用没有权限访问这个文件，则两者都返回false
		boolean path_exists = Files.exists(path,
				new LinkOption[] { LinkOption.NOFOLLOW_LINKS });
		boolean path_notexists = Files.notExists(path,
				new LinkOption[] { LinkOption.NOFOLLOW_LINKS });
		System.out.println(path_exists);
		System.out.println(path_notexists);

		// 检测文件访问权限
		boolean is_readable = Files.isReadable(path);
		boolean is_writable = Files.isWritable(path);
		boolean is_executable = Files.isExecutable(path);
		boolean is_regular = Files.isRegularFile(path,
				LinkOption.NOFOLLOW_LINKS);
		if ((is_readable) && (is_writable) && (is_executable) && (is_regular)) {
			System.out.println("The checked file is accessible!");
		} else {
			System.out.println("The checked file is not accessible!");
		}

		// 检测文件是否指定同一个文件
		Path path_1 = FileSystems.getDefault().getPath(
				System.getProperty("user.home"), "www", "pyweb.settings");
		Path path_2 = FileSystems.getDefault().getPath(
				System.getProperty("user.home"), "www", "django.wsgi");
		Path path_3 = FileSystems.getDefault().getPath(
				System.getProperty("user.home"), "software/../www",
				"pyweb.settings");
		try {
			boolean is_same_file_12 = Files.isSameFile(path_1, path_2);
			boolean is_same_file_13 = Files.isSameFile(path_1, path_3);
			boolean is_same_file_23 = Files.isSameFile(path_2, path_3);
			System.out.println("is same file 1&2 ? " + is_same_file_12);
			System.out.println("is same file 1&3 ? " + is_same_file_13);
			System.out.println("is same file 2&3 ? " + is_same_file_23);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 检测文件可见行
		try {
			boolean is_hidden = Files.isHidden(path);
			System.out.println("Is hidden ? " + is_hidden);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 获取文件系统根目录
		Iterable<Path> dirs = FileSystems.getDefault().getRootDirectories();
		for (Path name : dirs) {
			System.out.println(name);
		}
		// jdk6的API
		// File[] roots = File.listRoots();
		// for (File root : roots) {
		// System.out.println(root);
		// }

		// 创建新目录
		Path newdir = FileSystems.getDefault().getPath("/tmp/aaa");
		// try {
		// Files.createDirectory(newdir);
		// } catch (IOException e) {
		// System.err.println(e);
		// }
		Set<PosixFilePermission> perms = PosixFilePermissions
				.fromString("rwxr-x---");
		FileAttribute<Set<PosixFilePermission>> attr = PosixFilePermissions
				.asFileAttribute(perms);
		try {
			Files.createDirectory(newdir, attr);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 创建多级目录,创建bbb目录，在bbb目录下再创建ccc目录等等
		Path newdir2 = FileSystems.getDefault().getPath("/tmp/aaa",
				"/bbb/ccc/ddd");
		try {
			Files.createDirectories(newdir2);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 列举目录信息
		Path newdir3 = FileSystems.getDefault().getPath("/tmp");
		try (DirectoryStream<Path> ds = Files.newDirectoryStream(newdir3)) {
			for (Path file : ds) {
				System.out.println(file.getFileName());
			}
		} catch (IOException e) {
			System.err.println(e);
		}
		// 通过正则表达式过滤
		System.out.println("\nGlob pattern applied:");
		try (DirectoryStream<Path> ds = Files.newDirectoryStream(newdir3,
				"*.{png,jpg,bmp，ini}")) {
			for (Path file : ds) {
				System.out.println(file.getFileName());
			}
		} catch (IOException e) {
			System.err.println(e);
		}

		// 创建新文件
		Path newfile = FileSystems.getDefault().getPath(
				"/tmp/SonyEricssonOpen.txt");
		Set<PosixFilePermission> perms1 = PosixFilePermissions
				.fromString("rw-------");
		FileAttribute<Set<PosixFilePermission>> attr2 = PosixFilePermissions
				.asFileAttribute(perms1);
		try {
			Files.createFile(newfile, attr2);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 写小文件
		try {
			byte[] rf_wiki_byte = "test".getBytes("UTF-8");
			Files.write(newfile, rf_wiki_byte);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 读小文件
		try {
			byte[] ballArray = Files.readAllBytes(newfile);
			System.out.println(ballArray.toString());
		} catch (IOException e) {
			System.out.println(e);
		}
		Charset charset = Charset.forName("ISO-8859-1");
		try {
			List<String> lines = Files.readAllLines(newfile, charset);
			for (String line : lines) {
				System.out.println(line);
			}
		} catch (IOException e) {
			System.out.println(e);
		}

		// 读写文件缓存流操作
		String text = "\nVamos Rafa!";
		try (BufferedWriter writer = Files.newBufferedWriter(newfile, charset,
				StandardOpenOption.APPEND)) {
			writer.write(text);
		} catch (IOException e) {
			System.err.println(e);
		}
		try (BufferedReader reader = Files.newBufferedReader(newfile, charset)) {
			String line = null;
			while ((line = reader.readLine()) != null) {
				System.out.println(line);
			}
		} catch (IOException e) {
			System.err.println(e);
		}

		// 不用缓存的输入输出流
		String racquet = "Racquet: Babolat AeroPro Drive GT";
		byte data[] = racquet.getBytes();
		try (OutputStream outputStream = Files.newOutputStream(newfile)) {
			outputStream.write(data);
		} catch (IOException e) {
			System.err.println(e);
		}
		String string = "\nString: Babolat RPM Blast 16";
		try (OutputStream outputStream = Files.newOutputStream(newfile,
				StandardOpenOption.APPEND);
				BufferedWriter writer = new BufferedWriter(
						new OutputStreamWriter(outputStream))) {
			writer.write(string);
		} catch (IOException e) {
			System.err.println(e);
		}
		int n;
		try (InputStream in = Files.newInputStream(newfile)) {
			while ((n = in.read()) != -1) {
				System.out.print((char) n);
			}
		} catch (IOException e) {
			System.err.println(e);
		}

		// 临时目录操作
		String tmp_dir_prefix = "nio_";
		try {
			// passing null prefix
			Path tmp_1 = Files.createTempDirectory(null);
			System.out.println("TMP: " + tmp_1.toString());
			// set a prefix
			Path tmp_2 = Files.createTempDirectory(tmp_dir_prefix);
			System.out.println("TMP: " + tmp_2.toString());

			// 删除临时目录
			Path basedir = FileSystems.getDefault().getPath("/tmp/aaa");
			Path tmp_dir = Files.createTempDirectory(basedir, tmp_dir_prefix);
			File asFile = tmp_dir.toFile();
			asFile.deleteOnExit();

		} catch (IOException e) {
			System.err.println(e);
		}

		String tmp_file_prefix = "rafa_";
		String tmp_file_sufix = ".txt";
		try {
			// passing null prefix/suffix
			Path tmp_1 = Files.createTempFile(null, null);
			System.out.println("TMP: " + tmp_1.toString());
			// set a prefix and a suffix
			Path tmp_2 = Files.createTempFile(tmp_file_prefix, tmp_file_sufix);
			System.out.println("TMP: " + tmp_2.toString());
			File asFile = tmp_2.toFile();
			asFile.deleteOnExit();

		} catch (IOException e) {
			System.err.println(e);
		}

		// 删除文件
		try {
			boolean success = Files.deleteIfExists(newdir2);
			System.out.println("Delete status: " + success);
		} catch (IOException | SecurityException e) {
			System.err.println(e);
		}

		// 拷贝文件
		Path copy_from = Paths.get("/tmp", "draw_template.txt");
		Path copy_to = Paths
				.get("/tmp/bbb", copy_from.getFileName().toString());
		try {
			Files.copy(copy_from, copy_to);
		} catch (IOException e) {
			System.err.println(e);
		}
		try (InputStream is = new FileInputStream(copy_from.toFile())) {
			Files.copy(is, copy_to);
		} catch (IOException e) {
			System.err.println(e);
		}
		//移动文件
		Path movefrom = FileSystems.getDefault().getPath(
				"C:/rafaelnadal/rafa_2.jpg");
		Path moveto = FileSystems.getDefault().getPath(
				"C:/rafaelnadal/photos/rafa_2.jpg");
		try {
			Files.move(movefrom, moveto, StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			System.err.println(e);
		}

	}

}
