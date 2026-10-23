<%@page import = "mg.allosakafo.stock.BonDeCommande"%>
<%@page import = "user.*" %>
<%@page import = "utilitaire.*" %>
<%@page import = "bean.*" %>
<%@page import = "java.sql.SQLException" %>
<%@page import = "affichage.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <%!
        UserEJB u = null;
        String acte = null;
        String lien = null;
        String bute;
        String nomtable;
        String typeBoutton;
    %>
    <%
        try {
            nomtable = request.getParameter("nomtable");
            typeBoutton = request.getParameter("type");
            lien = (String) session.getValue("lien");
            u = (UserEJB) session.getAttribute("u");
            acte = request.getParameter("acte");
            bute = request.getParameter("bute");
            Object temp = null;
            String[] rajoutLien = null;
            String classe = request.getParameter("classe");
            ClassMAPTable t = null;
            String tempRajout = request.getParameter("rajoutLien");
            String val = "";

            String rajoutLie = "";
            if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
                rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
            }

            if (acte.compareToIgnoreCase("modifRecette") == 0) {
                String taille = request.getParameter("taille");
				String nbrLigne = request.getParameter("nbrLigne");
                String[] actionligne = request.getParameterValues("actionligne");
				String[] idIngredients = request.getParameterValues("idIngredients");
				String[] libs = request.getParameterValues("libs");
				String[] qte = request.getParameterValues("qte");
				val = request.getParameter("id");
				
				u.modifierRecette(actionligne, idIngredients, libs, qte, val);
            }
             
    %>
    <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=val%>");</script>
    <%

    } catch (Exception e) {
        e.printStackTrace();
    %>

    <script language="JavaScript"> alert('<%=e.getMessage()%>');
        history.back();</script>
        <%
                return;
            }
        %>
</html>



