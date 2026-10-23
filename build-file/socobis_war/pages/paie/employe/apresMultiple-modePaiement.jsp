<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="user.UserEJB" %>
<%@ page import="utilitaire.Utilitaire" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
    try {
        String lien = (String) session.getValue("lien");
        UserEJB u = (UserEJB) session.getAttribute("u");
        String acte = request.getParameter("acte");
        String bute = request.getParameter("bute");
        String classe = request.getParameter("classe");
        String classefille = request.getParameter("classefille");
        String nombreDeLigne = request.getParameter("nombreLigne");
        String[] tId = request.getParameterValues("ids");
        int nbLine = Utilitaire.stringToInt(nombreDeLigne);

        if (acte != null && acte.compareToIgnoreCase("update") == 0) {
            ClassMAPTable mere = (ClassMAPTable) Class.forName(classe).newInstance();
            ClassMAPTable fille = (ClassMAPTable) Class.forName(classefille).newInstance();
            PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();

            for (int i = 0; i < cfille.length; i++) {
                u.updateObject(cfille[i]);
            }
%>
<script language="JavaScript">document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%
        }
    } catch (Exception ex) {
        ex.printStackTrace();
%>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<%
        return;
    }
%>
</html>
