
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.file.FileStore;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.AclEntry;
import java.nio.file.attribute.AclEntryPermission;
import java.nio.file.attribute.AclEntryType;
import java.nio.file.attribute.AclFileAttributeView;
import java.nio.file.attribute.BasicFileAttributeView;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.DosFileAttributes;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.FileOwnerAttributeView;
import java.nio.file.attribute.FileStoreAttributeView;
import java.nio.file.attribute.FileTime;
import java.nio.file.attribute.GroupPrincipal;
import java.nio.file.attribute.PosixFileAttributeView;
import java.nio.file.attribute.PosixFileAttributes;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.attribute.UserDefinedFileAttributeView;
import java.nio.file.attribute.UserPrincipal;
import java.util.List;
import java.util.Set;

import static java.nio.file.LinkOption.NOFOLLOW_LINKS;

public class NIO2FileAttribute {

	public static void main(String[] args) {
		FileSystem fs = FileSystems.getDefault();
		Set<String> views = fs.supportedFileAttributeViews();
		for (String view : views) {
			System.out.println(view);
		}
		/*
		 * BasicFileAttributeView: This is a view of basic attributes that must
		 * be supported by all file system implementations. The attribute view
		 * name is basic. ? DosFileAttributeView: This view provides the
		 * standard four supported attributes on file systems that support the
		 * DOS attributes. The attribute view name is dos. ?
		 * PosixFileAttributeView: This view extends the basic attribute view
		 * with attributes supported on file systems that support the POSIX
		 * (Portable Operating System Interface for Unix) family of standards,
		 * such as Unix. The attribute view name is posix. ?
		 * FileOwnerAttributeView: This view is supported by any file system
		 * implementation that supports the concept of a file owner. The
		 * attribute view name is owner. ? AclFileAttributeView: This view
		 * supports reading or updating a file’s ACL. The NFSv4 ACL model is
		 * supported. The attribute view name is acl.
		 * UserDefinedFileAttributeView: This view enables support of metadata
		 * that is user defined.
		 */

		for (FileStore store : fs.getFileStores()) {
			boolean supported = store
					.supportsFileAttributeView(BasicFileAttributeView.class);
			System.out.println(store.name() + " ---" + supported);
		}
		Path path = null;
		try {
			path = Paths.get(System.getProperty("user.home"), "www",
					"pyweb.settings");
			FileStore store = Files.getFileStore(path);
			boolean supported = store.supportsFileAttributeView("basic");
			System.out.println(store.name() + " ---" + supported);
		} catch (IOException e) {
			System.err.println(e);
		}

		BasicFileAttributes attr = null;
		try {
			attr = Files.readAttributes(path, BasicFileAttributes.class);
		} catch (IOException e) {
			System.err.println(e);
		}
		System.out.println("File size: " + attr.size());
		System.out.println("File creation time: " + attr.creationTime());
		System.out.println("File was last accessed at: "
				+ attr.lastAccessTime());
		System.out.println("File was last modified at: "
				+ attr.lastModifiedTime());
		System.out.println("Is directory? " + attr.isDirectory());
		System.out.println("Is  regular file? " + attr.isRegularFile());
		System.out.println("Is  symbolic link? " + attr.isSymbolicLink());
		System.out.println("Is  other? " + attr.isOther());

		// 只获取某个属性 [view-name:]attribute-name
		/**
		 * Basic attribute names are listed here: lastModifiedTime
		 * lastAccessTime creationTime size isRegularFile isDirectory
		 * isSymbolicLink isOther fileKey
		 **/
		try {
			long size = (Long) Files.getAttribute(path, "basic:size",
					java.nio.file.LinkOption.NOFOLLOW_LINKS);
			System.out.println("Size: " + size);
		} catch (IOException e) {
			System.err.println(e);
		}
		// Update a Basic Attribute
		long time = System.currentTimeMillis();
		FileTime fileTime = FileTime.fromMillis(time);
		try {
			Files.getFileAttributeView(path, BasicFileAttributeView.class)
					.setTimes(fileTime, fileTime, fileTime);
		} catch (IOException e) {
			System.err.println(e);
		}
		try {
			Files.setLastModifiedTime(path, fileTime);
		} catch (IOException e) {
			System.err.println(e);
		}

		try {
			Files.setAttribute(path, "basic:lastModifiedTime", fileTime,
					NOFOLLOW_LINKS);
			Files.setAttribute(path, "basic:creationTime", fileTime,
					NOFOLLOW_LINKS);
			Files.setAttribute(path, "basic:lastAccessTime", fileTime,
					NOFOLLOW_LINKS);
		} catch (IOException e) {
			System.err.println(e);
		}
		// DosFileAttributeView DOS attributes can be acquired with the
		// following names:hidden readonly system archive
		DosFileAttributes docattr = null;
		try {
			docattr = Files.readAttributes(path, DosFileAttributes.class);
		} catch (IOException e) {
			System.err.println(e);
		}
		System.out.println("Is read only ? " + docattr.isReadOnly());
		System.out.println("Is Hidden ? " + docattr.isHidden());
		System.out.println("Is archive ? " + docattr.isArchive());
		System.out.println("Is  system ? " + docattr.isSystem());

		// FileOwnerAttributeView
		// Set a File Owner Using Files.setOwner() 三种设置文件所有者的方法
		UserPrincipal owner = null;
		try {
			owner = path.getFileSystem().getUserPrincipalLookupService()
					.lookupPrincipalByName("vita");
			Files.setOwner(path, owner);
		} catch (IOException e) {
			System.err.println(e);
		}
		FileOwnerAttributeView foav = Files.getFileAttributeView(path,
				FileOwnerAttributeView.class);
		try {
			owner = path.getFileSystem().getUserPrincipalLookupService()
					.lookupPrincipalByName("vita");
			foav.setOwner(owner);
		} catch (IOException e) {
			System.err.println(e);
		}
		try {
			owner = path.getFileSystem().getUserPrincipalLookupService()
					.lookupPrincipalByName("vita");
			Files.setAttribute(path, "owner:owner", owner, NOFOLLOW_LINKS);
		} catch (IOException e) {
			System.err.println(e);
		}
		// 获取文件所有者
		try {
			String ownerName = foav.getOwner().getName();
			System.out.println(ownerName);
		} catch (IOException e) {
			System.err.println(e);
		}
		try {
			UserPrincipal owner1 = (UserPrincipal) Files.getAttribute(path,
					"owner:owner", NOFOLLOW_LINKS);
			System.out.println(owner1.getName());
		} catch (IOException e) {
			System.err.println(e);
		}

		// POSIX View file owner, group owner, and nine related access
		// permissions (read, write, members of the same group, etc.). ?group
		// permissions

		PosixFileAttributes positattr = null;
		try {
			positattr = Files.readAttributes(path, PosixFileAttributes.class);
		} catch (IOException e) {
			System.err.println(e);
		}
		System.out.println("File owner: " + positattr.owner().getName());
		System.out.println("File group: " + positattr.group().getName());
		System.out.println("File permissions: "
				+ positattr.permissions().toString());

		// 设置文件访问权限
		FileAttribute<Set<PosixFilePermission>> posixattrs = PosixFilePermissions
				.asFileAttribute(positattr.permissions());
		try {
			Files.createFile(path, posixattrs);
		} catch (IOException e) {
			System.err.println(e);
		}
		Set<PosixFilePermission> permissions = PosixFilePermissions
				.fromString("rw-r--r--");
		try {
			Files.setPosixFilePermissions(path, permissions);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 设置分组用户
		try {
			GroupPrincipal group = path.getFileSystem()
					.getUserPrincipalLookupService()
					.lookupPrincipalByGroupName("apressteam");
			Files.getFileAttributeView(path, PosixFileAttributeView.class)
					.setGroup(group);
		} catch (IOException e) {
			System.err.println(e);
		}

		// 查询组用户
		try {
			GroupPrincipal group = (GroupPrincipal) Files.getAttribute(path,
					"posix:group", NOFOLLOW_LINKS);
			System.out.println(group.getName());
		} catch (IOException e) {
			System.err.println(e);
		}

		// ACL View access control list acl owner
		// 查询acl属性
		List<AclEntry> acllist = null;
		AclFileAttributeView aclview = Files.getFileAttributeView(path,
				AclFileAttributeView.class);
		try {
			acllist = aclview.getAcl();
			for (AclEntry aclentry : acllist) {
				System.out
						.println("++++++++++++++++++++++++++++++++++++++++++++++++++++");
				System.out.println("Principal: "
						+ aclentry.principal().getName());
				System.out.println("Type: " + aclentry.type().toString());
				System.out.println("Permissions: "
						+ aclentry.permissions().toString());
				System.out.println("Flags: " + aclentry.flags().toString());
			}
		} catch (Exception e) {
			System.err.println(e);
		}

		// 设置ACL属性
		try {
			// Lookup for the principal
			UserPrincipal user = path.getFileSystem()
					.getUserPrincipalLookupService()
					.lookupPrincipalByName("apress");
			// Get the ACL view
			AclFileAttributeView view = Files.getFileAttributeView(path,
					AclFileAttributeView.class);
			// Create a new entry
			AclEntry entry = AclEntry
					.newBuilder()
					.setType(AclEntryType.ALLOW)
					.setPrincipal(user)
					.setPermissions(AclEntryPermission.READ_DATA,
							AclEntryPermission.APPEND_DATA).build();
			// read ACL
			List<AclEntry> acl = view.getAcl();
			// Insert the new entry
			acl.add(0, entry);
			// rewrite ACL
			view.setAcl(acl);
			// or, like this
			// Files.setAttribute(path, "acl:acl", acl, NOFOLLOW_LINKS);
		} catch (IOException e) {
			System.err.println(e);
		}

		// File Store Attributes
		// 获取所有的fifilestore的属性信息
		FileSystem fs1 = FileSystems.getDefault();
		for (FileStore store : fs1.getFileStores()) {
			try {
				long total_space = store.getTotalSpace() / 1024;
				long used_space = (store.getTotalSpace() - store
						.getUnallocatedSpace()) / 1024;
				long available_space = store.getUsableSpace() / 1024;
				boolean is_read_only = store.isReadOnly();
				System.out.println("--- " + store.name() + " --- "
						+ store.type());
				System.out.println("Total space: " + total_space);
				System.out.println("Used space: " + used_space);
				System.out.println("Available space: " + available_space);
				System.out.println("Is read only? " + is_read_only);
			} catch (IOException e) {
				System.err.println(e);
			}
		}

		// 获取某个文件的fifilestore，再查询filestroe的属性信息
		try {
			FileStore store = Files.getFileStore(path);
			FileStoreAttributeView fsav = store
					.getFileStoreAttributeView(FileStoreAttributeView.class);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// User-Defined File Attributes View 用户自定义文件属性
		// 检测文件系统是否支持自定义属性
		try {
			FileStore store = Files.getFileStore(path);
			if (!store
					.supportsFileAttributeView(UserDefinedFileAttributeView.class)) {
				System.out
						.println("The user defined attributes are not supported on: "
								+ store);
			} else {
				System.out
						.println("The user defined attributes are supported on: "
								+ store);
			}
		} catch (IOException e) {
			System.err.println(e);
		}
		// 设置文件属性
		UserDefinedFileAttributeView udfav = Files.getFileAttributeView(path,
				UserDefinedFileAttributeView.class);
		try {
			int written = udfav.write(
					"file.description",
					Charset.defaultCharset().encode(
							"This file contains private information!"));
			System.out.println("write user defined file attribute return :"
					+ written);
		} catch (IOException e) {
			System.err.println(e);
		}
		// 获取文件的所有自定义属性
		try {
			for (String name : udfav.list()) {
				System.out.println(udfav.size(name) + "" + name);
			}
		} catch (IOException e) {
			System.err.println(e);
		}
		try {
			int size = udfav.size("file.description");
			ByteBuffer bb = ByteBuffer.allocateDirect(size);
			udfav.read("file.description", bb);
			bb.flip();
			System.out.println(Charset.defaultCharset().decode(bb).toString());
		} catch (IOException e) {
			System.err.println(e);
		}
		//删除自定义文件属性
		try {
			udfav.delete("file.description");
		} catch (IOException e) {
			System.err.println(e);
		}

	}
}

