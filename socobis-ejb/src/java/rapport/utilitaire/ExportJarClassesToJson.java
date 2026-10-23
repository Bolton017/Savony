package rapport.utilitaire;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.lang.reflect.Field;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.CodeSource;
import java.util.*;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

public class ExportJarClassesToJson {

    public String[] classNames;

    public String[] getClassNames() {
        return classNames;
    }

    public void setClassNames(String[] classNames) {
        this.classNames = classNames;
    }

    public List<String> exportProjectEjbClasses() {
        List<String> classes = new ArrayList<String>();
        try {
            CodeSource src = ExportJarClassesToJson.class.getProtectionDomain().getCodeSource();
            if (src == null) {
                throw new RuntimeException("Impossible de localiser le code source pour obtenir le chemin du JAR.");
            }
            URL jarUrl = src.getLocation();
            String decodedPath = URLDecoder.decode(jarUrl.getPath(), "UTF-8");
            if (!decodedPath.endsWith(ConstanteCR.JAR_NAME)) {
                decodedPath = decodedPath.replace(ConstanteCR.PROJECT_NAME+"/WEB-INF/classes/", ConstanteCR.JAR_NAME);
            }

            JarFile jarFile = new JarFile(decodedPath);
            Enumeration<JarEntry> entries = jarFile.entries();

            List<Map<String, Object>> classesInfo = new ArrayList<>();

            while (entries.hasMoreElements()) {
                JarEntry entry = entries.nextElement();
                if (entry.isDirectory() || !entry.getName().endsWith(".class")) {
                    continue;
                }

                String className = entry.getName().replace('/', '.').replace(".class", "");

                try {
                    Map<String, Object> classInfo = new HashMap<>();
                    Class<?> cls = Class.forName(className);

                    classInfo.put("className", cls.getName());
                    classInfo.put("package", cls.getPackage() != null ? cls.getPackage().getName() : "");

                    classes.add((String)classInfo.get("className"));

                    this.mapAttributes(classInfo, cls);

                    classesInfo.add(classInfo);
                } catch (Throwable ex) {
                    System.out.println("Impossible de charger : " + className + " --> " + ex.getMessage());
                }
            }
            jarFile.close();

            ObjectMapper mapper = new ObjectMapper();

            String dir = ConstanteCR.BASE_DIR+"/"+ConstanteCR.PROJECT_NAME+"/Json/";
            UtilitaireCR.createDirectory(dir);
            dir += "all_classes.json";
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(dir), classesInfo);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return classes;
    }

    public void mapAttributes(Map<String, Object> classInfo, Class<?> cls)throws Exception{

        List<String> attributes = new ArrayList<>();

        Class<?> currentClass = cls;

        while (currentClass != null && currentClass != Object.class) {
            for (Field field : currentClass.getDeclaredFields()) {
                if (!attributes.contains(field.getName())) {
                    attributes.add(field.getName());
                }
            }

            try {
                CodeSource parentSrc = currentClass.getSuperclass().getProtectionDomain().getCodeSource();
                if (parentSrc != null) {

                    URL url = parentSrc.getLocation();
                    if(url==null){
                        break;
                    }
                    String location = url.toString();

                    String[] licationSplitted = location.split("/");

                    String jarName = licationSplitted[licationSplitted.length-1];

                    if (!jarName.equals(ConstanteCR.JAR_NAME)) {
                        break;
                    }
                } else {
                    break;
                }
            } catch (Exception e) {
                System.out.println("Erreur: "+e.getMessage());
                break;
            }

            currentClass = currentClass.getSuperclass();
        }
        classInfo.put("attributes", attributes);
    }

    public String castJsonToString()throws Exception{
        String dir = ConstanteCR.BASE_DIR+"/"+ConstanteCR.PROJECT_NAME+"/Json/";
        dir += "all_classes.json";
        String jsonPath = dir;
        String jsonContent = new String(Files.readAllBytes(Paths.get(jsonPath)), StandardCharsets.UTF_8);
        JSONArray jsonArray = new JSONArray(jsonContent);
        List<String> classNames = new ArrayList<String>();
        StringBuilder jsMap = new StringBuilder();
        jsMap.append("classesMap = {\n");

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            String className = obj.getString("className");
            JSONArray attrs = obj.getJSONArray("attributes");
            classNames.add(className);

            jsMap.append("\"").append(className).append("\": [");
            for (int j = 0; j < attrs.length(); j++) {
                jsMap.append("\"").append(attrs.getString(j).replace("\"", "\\\"")).append("\"");
                if (j < attrs.length() - 1) jsMap.append(", ");
            }
            jsMap.append("]");
            if (i < jsonArray.length() - 1) jsMap.append(",\n");
        }
        jsMap.append("\n};");

        String[] className = classNames.toArray(new String[0]);
        this.setClassNames(className);

        return jsMap.toString();
    }
}
