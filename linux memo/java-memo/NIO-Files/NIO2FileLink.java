import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFileAttributes;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.Set;

public class NIO2FileLink {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Path link = FileSystems.getDefault().getPath(
				System.getProperty("user.home"), "www",
				"pyweb.settings");
		Path target = FileSystems.getDefault().getPath(
				System.getProperty("user.home"), "www",
				"testlink");

		// 创建软链接
		try {
            System.out.println(link+"<--------->"+target);
            
			Files.createSymbolicLink(link, target);
            
			// 创建软链接时设置软链接的属性
			PosixFileAttributes attrs = Files.readAttributes(target,
					PosixFileAttributes.class);
			FileAttribute<Set<PosixFilePermission>> attr = PosixFilePermissions
					.asFileAttribute(attrs.permissions());
			Files.createSymbolicLink(link, target, attr);

		} catch (IOException | UnsupportedOperationException
				| SecurityException e) {
			if (e instanceof SecurityException) {
				System.err.println("Permission denied!");
			}
			if (e instanceof UnsupportedOperationException) {
				System.err.println("An unsupported operation was detected!");
			}
			if (e instanceof IOException) {
				System.err.println("An I/O error occurred!");
			}
			System.err.println(e);
		}

		// 检查是否是软链接
		boolean link_isSymbolicLink_1 = Files.isSymbolicLink(link);
		boolean target_isSymbolicLink_1 = Files.isSymbolicLink(target);
		System.out.println(link.toString() + " is a symbolic link ? "
				+ link_isSymbolicLink_1);
		System.out.println(target.toString() + " is a symbolic link ? "
				+ target_isSymbolicLink_1);

		try {
			boolean link_isSymbolicLink_2 = (boolean) Files.getAttribute(link,
					"basic:isSymbolicLink");
			boolean target_isSymbolicLink_2 = (boolean) Files.getAttribute(
					target, "basic:isSymbolicLink");
			System.out.println(link.toString() + " is a symbolic link ? "
					+ link_isSymbolicLink_2);
			System.out.println(target.toString() + " is a symbolic link ? "
					+ target_isSymbolicLink_2);
		} catch (IOException | UnsupportedOperationException e) {
			System.err.println(e);
		}

		//读取软链接对应的文件
		try {
			Path linkedpath = Files.readSymbolicLink(link);
			System.out.println(linkedpath.toString());
		} catch (IOException e) {
			System.err.println(e);
		}

		// 创建硬链接
		try {
			Files.createLink(link, target);
			System.out.println("The link was successfully created!");
		} catch (IOException | UnsupportedOperationException
				| SecurityException e) {
			if (e instanceof SecurityException) {
				System.err.println("Permission denied!");
			}
			if (e instanceof UnsupportedOperationException) {
				System.err.println("An unsupported operation was detected!");
			}
			if (e instanceof IOException) {
				System.err.println("An I/O error occured!");
			}
			System.err.println(e);
		}
	}
}

