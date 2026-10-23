<%@ page import="rapport.utilitaire.ExportJarClassesToJson" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>

<%
ExportJarClassesToJson exportJarClassesToJson = new ExportJarClassesToJson();
List<String> classes = exportJarClassesToJson.exportProjectEjbClasses();

for (String clsName : classes) {
    out.println(clsName);
}
%>
