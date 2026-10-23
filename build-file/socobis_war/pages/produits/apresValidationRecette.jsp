<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="produits.RecetteMere" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String idIngredient = null;
%>
<%
    try {
        nomtable = request.getParameter("nomtable");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        idIngredient = request.getParameter("idIngredient");
        String ids[] = request.getParameterValues("ids");
        RecetteMere recette = new RecetteMere();
        if (acte != null && acte.compareToIgnoreCase("validerMultiple") == 0) {
            if (ids != null && ids.length == 1){
                recette.validerRecettePrincipale(u.getUser().getTuppleID(),ids[0]);
                bute += "&id=" + idIngredient;
            } else { %>
                <script type="text/javascript">alert('Une seule recette peut \u00eatre utilis\u00e9e en tant que recette principale');; history.back();</script>
            <% }
        }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%
} catch (Exception ex) {
    ex.printStackTrace(); %>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<% return; } %>
</html>