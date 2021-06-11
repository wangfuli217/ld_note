import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;

//NIO 2 file APi filesystem filestore
public class NIO2File {

	public static void main(String[] args) {
		try {
			// FileSystems.getDefault().getPath(first, more)
			Path path = Paths.get(System.getProperty("user.home"), "www",
					"pyweb.settings");
			Path real_path = path.toRealPath(LinkOption.NOFOLLOW_LINKS);
			System.out.println("Path to real path: " + real_path);

			System.out.println("Number of name elements in path: "
					+ path.getNameCount());
			for (int i = 0; i < path.getNameCount(); i++) {
				System.out.println("Name element " + i + " is: "
						+ path.getName(i));
			}
            //subpath方法用来获取当前路径的子路径，参数中的序号表示的是路径中名称元素的序号；
			System.out.println("Subpath (0,3): " + path.subpath(0, 3));

			File path_to_file = path.toFile();
			Path file_to_path = path_to_file.toPath();
			System.out.println("Path to file name: " + path_to_file.getName());
			System.out.println("File to path: " + file_to_path.toString());

			Path base = Paths.get(System.getProperty("user.home"), "www",
					"pyweb.settings");
			// Path接口中resolve方法的作用相当于把当前路径当成父目录，而把参数中的路径当成子目录或是其中的文件，进行解析之后得到一个新路径；
			Path path1 = base.resolve("django.wsgi");
			System.out.println("path.resolve:"+path1.toString());
            // resolveSibling方法的作用与resolve方法类似，只不过把当前路径的父目录当成解析时的父目录；
			Path path2 = base.resolveSibling(".bashrc");
			System.out.println("path.resolveSibling:"+path2.toString());
            //relativize方法的作用与resolve方法正好相反，用来计算当前路径相对于参数中给出的路径的相对路径；
			Path path01_to_path02 = path1.relativize(path2);
			System.out.println(path01_to_path02);

			try {
				boolean check = Files.isSameFile(path1.getParent(),
						path2.getParent());
				if (check) {
					System.out.println("The paths locate the same file!"); // true
				} else {
					System.out
							.println("The paths does not locate the same file!");
				}
			} catch (IOException e) {
				System.out.println(e.getMessage());
			}
            //startsWith和endsWith方法用来判断当前路径是否以参数中的路径开始或结尾。
			boolean sw = path1.startsWith("/rafaelnadal/tournaments");
			boolean ew = path1.endsWith("django.wsgi");
			System.out.println(sw);
			System.out.println(ew);

			for (Path name : path1) {
				System.out.println(name);
			}

		} catch (NoSuchFileException e) {
			System.err.println(e);
		} catch (IOException e) {
			System.err.println(e);
		}

	}
}
