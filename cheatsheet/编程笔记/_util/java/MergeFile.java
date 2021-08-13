package com.everunion.util;

import java.io.FileOutputStream;
import java.io.IOException;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.pdf.PdfCopy;
import com.lowagie.text.pdf.PdfImportedPage;
import com.lowagie.text.pdf.PdfReader;

public class MergeFile
{
	public static void main(String[] args)
	{
		String[] files = { "e:\\1.pdf", "e:\\2.pdf" , "e:\\3.pdf"};
		String savepath = "e:\\temp.pdf";
		mergePdfFiles(files, savepath);

	}
	
	/*
	 * 合並pdf文件
	 * 
	 * @param files 要合並文件數組(絕對路徑如{ "e:\\1.pdf", "e:\\2.pdf" , "e:\\3.pdf"})
	 * @param newfile 合並後新產生的文件絕對路徑如e:\\temp.pdf,請自己刪除用過後不再用的文件請
	 * @return boolean 產生成功返回true, 否則返回false
	 */
	public static boolean mergePdfFiles(String[] files, String newfile)
	{
		boolean retValue = false;
		Document document = null;
		try
		{
			document = new Document(new PdfReader(files[0]).getPageSize(1));
			PdfCopy copy = new PdfCopy(document, new FileOutputStream(newfile));
			document.open();
			for (int i = 0; i < files.length; i++)
			{
				PdfReader reader = new PdfReader(files[i]);
				int n = reader.getNumberOfPages();
				for (int j = 1; j <= n; j++)
				{
					document.newPage();
					PdfImportedPage page = copy.getImportedPage(reader, j);
					copy.addPage(page);
				}
			}
			
			retValue = true;
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		catch (DocumentException e)
		{
			e.printStackTrace();
		}
		finally
		{
			document.close();
		}
		return retValue;
	}
}