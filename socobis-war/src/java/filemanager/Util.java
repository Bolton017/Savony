package filemanager;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

public class Util {

    public static String BASE_DIR = System.getProperty("jboss.server.base.dir") + "/deployments/dossier.war/async";
    public static String base = "";

    private static final SimpleDateFormat DF = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    private static File rootDir() throws IOException {
        return new File(BASE_DIR).getCanonicalFile();
    }

    public static File resolveSafe(String relative) throws IOException {
        File root = rootDir();
        File target = new File(root, relative == null ? "" : relative).getCanonicalFile();
        String rootPath = root.getPath();
        String targetPath = target.getPath();
        if (targetPath.equals(rootPath) || targetPath.startsWith(rootPath + File.separator)) {
            return target;
        }
        return null;
    }

    public static String humanSize(long bytes) {
        if (bytes < 1024) {
            return bytes + " o";
        }
        String[] u = {"Ko", "Mo", "Go", "To"};
        double v = bytes;
        int i = -1;
        do {
            v /= 1024;
            i++;
        } while (v >= 1024 && i < u.length - 1);
        return String.format("%.1f %s", v, u[i]);
    }

    public static String ext(File f) {
        String n = f.getName();
        int i = n.lastIndexOf('.');
        return (i > 0 && i < n.length() - 1) ? n.substring(i + 1).toLowerCase() : "";
    }

    public static synchronized String dateModif(File f) {
        return DF.format(new Date(f.lastModified()));
    }

    public static boolean isPreviewable(File f) {
        String e = ext(f);
        return e.equals("pdf") || e.equals("png") || e.equals("jpg")
                || e.equals("jpeg") || e.equals("gif");
    }

    public static String previewKind(File f) {
        String e = ext(f);
        if (e.equals("pdf")) {
            return "pdf";
        }
        if (e.equals("png") || e.equals("jpg") || e.equals("jpeg") || e.equals("gif")) {
            return "image";
        }
        return "";
    }

    public static String enc(String s) {
        try {
            return URLEncoder.encode(s == null ? "" : s, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }

    public static String iconClass(File f) {
        if (f.isDirectory()) {
            return "fa fa-folder ged-folder";
        }
        String e = ext(f);
        if (e.equals("pdf")) {
            return "fa fa-file-pdf-o ged-pdf";
        }
        if (e.equals("xls") || e.equals("xlsx") || e.equals("csv")) {
            return "fa fa-file-excel-o ged-xls";
        }
        if (e.equals("doc") || e.equals("docx")) {
            return "fa fa-file-word-o ged-doc";
        }
        if (e.equals("ppt") || e.equals("pptx")) {
            return "fa fa-file-powerpoint-o ged-ppt";
        }
        if (e.equals("png") || e.equals("jpg") || e.equals("jpeg") || e.equals("gif") || e.equals("bmp")) {
            return "fa fa-file-image-o ged-img";
        }
        if (e.equals("zip") || e.equals("rar") || e.equals("7z")) {
            return "fa fa-file-archive-o ged-file";
        }
        if (e.equals("json") || e.equals("xml") || e.equals("js") || e.equals("html") || e.equals("css") || e.equals("java") || e.equals("sql")) {
            return "fa fa-file-code-o ged-code";
        }
        if (e.equals("txt")) {
            return "fa fa-file-text-o ged-file";
        }
        return "fa fa-file-o ged-file";
    }

    public static String typeText(File f) {
        if (f.isDirectory()) {
            return "Dossier";
        }
        String e = ext(f);
        if (e.equals("pdf")) {
            return "Document PDF";
        }
        if (e.equals("xls") || e.equals("xlsx")) {
            return "Classeur Excel";
        }
        if (e.equals("csv")) {
            return "Fichier CSV";
        }
        if (e.equals("doc") || e.equals("docx")) {
            return "Document Word";
        }
        if (e.equals("ppt") || e.equals("pptx")) {
            return "Presentation PowerPoint";
        }
        if (e.equals("png") || e.equals("jpg") || e.equals("jpeg") || e.equals("gif") || e.equals("bmp")) {
            return "Image " + e.toUpperCase();
        }
        if (e.equals("zip") || e.equals("rar") || e.equals("7z")) {
            return "Archive";
        }
        if (e.equals("json")) {
            return "Document JSON";
        }
        if (e.equals("txt")) {
            return "Document texte";
        }
        if (e.isEmpty()) {
            return "Fichier";
        }
        return "Fichier " + e.toUpperCase();
    }

    public static List<File> list(File dir, String nameFilter, String col, String dir_) {
        List<File> out = new ArrayList<File>();
        File[] all = dir.listFiles();
        if (all == null) {
            return out;
        }
        String needle = nameFilter == null ? "" : nameFilter.trim().toLowerCase();
        for (File f : all) {
            if (needle.isEmpty() || f.getName().toLowerCase().contains(needle)) {
                out.add(f);
            }
        }
        final boolean desc = "1".equals(dir_);
        final String key = (col == null || col.isEmpty()) ? "name" : col;
        Collections.sort(out, new Comparator<File>() {
            @Override
            public int compare(File a, File b) {
                if (a.isDirectory() != b.isDirectory()) {
                    return a.isDirectory() ? -1 : 1;
                }
                int c;
                if ("size".equals(key)) {
                    c = Long.compare(a.length(), b.length());
                } else if ("date".equals(key)) {
                    c = Long.compare(a.lastModified(), b.lastModified());
                } else {
                    c = a.getName().compareToIgnoreCase(b.getName());
                }
                return desc ? -c : c;
            }
        });
        return out;
    }
}
