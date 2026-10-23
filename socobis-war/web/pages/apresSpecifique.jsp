<%--
    Document   : apresSpecifique
    Created on : 28 janv. 2021, 14:12:07
    Author     : Axel
--%>

<%@page import="paie.edition.EditionCalcul"%>
<%@page import="bean.ClassMAPTable"%>
<%@page import="user.UserEJB"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.sql.Date" %>
<%@page import="paie.log.LogPersonnelNonValide"%>
<%@ page import="paie.employe.PaieInfoPersonnel" %>
<%
    String acte = request.getParameter("acte");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String lien = (String) session.getValue("lien");
    String bute = request.getParameter("bute");

    try {
        if (acte.compareToIgnoreCase("genener_paie") == 0) {
            int mois = Integer.parseInt(request.getParameter("mois"));
            int annee = Integer.parseInt(request.getParameter("annee"));
            String rattachement = request.getParameter("rattachement")!=null?request.getParameter("rattachement"): "DIR00001";
            String idpersonnel = request.getParameter("idpersonnel")!=null ? request.getParameter("idpersonnel") : null;
            String categorie =request.getParameter("categorie");
            String idedition  = EditionCalcul.genererEditionPLSQLTahina(mois, annee, rattachement, "1060",idpersonnel,categorie);
            String table="PAIE_EDITIONMOISANNEE_lib";
            String pages = "editionmoisannee-fiche.jsp";
            bute = "paie/editionmoisannee/"+pages+"&id="+idedition+"&tab="+table;
        }
        
        if (acte.compareToIgnoreCase("genererStc") == 0) {
            String idlogpers = request.getParameter("id");
            System.out.println("Ato am specifique");
            System.out.println("val id non valide ===>"+idlogpers);
            LogPersonnelNonValide lgp = new LogPersonnelNonValide();
            lgp.setId(idlogpers);
            LogPersonnelNonValide[] logpers = (LogPersonnelNonValide[]) CGenUtil.rechercher(lgp, null, null, null, " AND ID = '"+idlogpers+"'");
            System.out.println("taille logpers ===>"+logpers.length);
            if (logpers.length>0){
                PaieInfoPersonnel pip = new PaieInfoPersonnel();
                pip.setId(logpers[0].getIdlogpers());
                System.out.println("log pers " + logpers[0].getIdlogpers());
                pip.setNbjpreavis(logpers[0].getDureePreavis());
                pip.setDate_depart(logpers[0].getDateapplication());
                pip.genererStc(idlogpers,u.getUser().getTuppleID(),logpers[0].getIdtypedebauche());
            }
            bute = request.getParameter("bute");
        }
%>
<script language="JavaScript">
    document.location.replace("<%=lien%>?but=<%=bute%>&id=<%= request.getParameter("id")%>");
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%
        return;
    }
%>