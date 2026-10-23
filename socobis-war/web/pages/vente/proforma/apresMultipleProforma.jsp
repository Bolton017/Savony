<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="vente.Vente" %>
<%@ page import="declaration.LiaisonCodeImpot" %>
<%@ page import="proforma.Proforma" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String[] tId;
    String idMere = null;
%>
<%
    try {
        nomtable = request.getParameter("nomtable");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        String colonneMere = request.getParameter("colonneMere");
        String classe = request.getParameter("classe");
        tId = request.getParameterValues("ids");
        String classefille = request.getParameter("classefille");
        ClassMAPTable mere = null;
        ClassMAPTable fille = null;
        String nombreDeLigne = request.getParameter("nombreLigne");

        int nbLine = Utilitaire.stringToInt(nombreDeLigne);
        if (acte != null && acte.compareToIgnoreCase("insert") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable cmere = p.getObjectAvecValeur();
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
            for (int i = 0; i < cfille.length; i++) {
                cfille[i].setNomTable(nomtable);
            }
            Proforma o =

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<% }
} catch (Exception ex) {
    ex.printStackTrace(); %>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<% return; } %>
</html>