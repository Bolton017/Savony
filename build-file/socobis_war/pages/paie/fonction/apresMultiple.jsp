<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="src.java.utils.ImportContext" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String[] tId;
%>
<%
    try {
        nomtable = request.getParameter("nomtable");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        String classe = request.getParameter("classe");
        tId = request.getParameterValues("ids");
        String classefille = request.getParameter("classefille");
        ClassMAPTable mere = null;
        ClassMAPTable fille = null;
        String nombreDeLigne = request.getParameter("nombreLigne");
        int nbLine = Utilitaire.stringToInt(nombreDeLigne);

        if (acte != null && acte.compareToIgnoreCase("insertFilleSeul") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
//            for (int i = 0; i < cfille.length; i++) {
//                ClassMAPTable t = cfille[i];
//                u.createObject(t);
//            }
            List<String> errs = new ArrayList<>();

            ImportContext.init(); // keep if needed internally

            u.createObjectMultiple(cfille);

            System.out.println(" Import errorrrrr ++++++++++ " + ImportContext.getErrors());

            List<String> contextErrors = ImportContext.getErrors();

            if (contextErrors != null && !contextErrors.isEmpty()) {
                errs.addAll(contextErrors);
            }

            if (!errs.isEmpty()) {
                session.setAttribute("importErrors", errs);
            }

            ImportContext.clear();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<% }
} catch (Exception ex) {
    ex.printStackTrace(); %>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<% return; } %>
</html>
