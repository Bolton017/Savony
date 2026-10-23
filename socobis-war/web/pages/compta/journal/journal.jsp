<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.PageRecherche" %>
<%@page import="mg.cnaps.compta.Journal" %>
<%@page import="affichage.PageInsert" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        Journal a = new Journal();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Code");
        pi.getFormu().getChamp("desce").setLibelle("Description");
        pi.getFormu().getChamp("compte").setPageAppelComplete("mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
<h1 class="box-title">Saisie Journal</h1>

    <section class="content">
        <form  action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="contrainte"
              id="contrainte"
              data-parsley-validate>
              <div class="col-md-12 mb-5 nopadding">
                  <%
                      pi.getFormu().makeHtmlInsertTabIndex();
                      out.println(pi.getFormu().getHtmlInsert());
                  %>
              </div>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="compta/journal/journal.jsp">
            <input name="classe" type="hidden" id="classe" value="mg.cnaps.compta.Journal">
        </form>

    <%
        Journal e = new Journal();
        e.setNomTable("COMPTA_JOURNAL_MOTSCLESSS");
        String listeCrt[] = {"id", "val", "desce", "compte"};
        String listeInt[] = null;
        String libEntete[] = {"id", "val", "desce","compte"};

        PageRecherche pr = new PageRecherche(e, request, listeCrt, listeInt, 2, libEntete, 2);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("compta/journal/journal.jsp");
        String[] colSomme = null;
         pr.setAWhere(" order by val asc");
        pr.creerObjetPage(libEntete, colSomme);

        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("val").setLibelle("Code");
        pr.getFormu().getChamp("desce").setLibelle("Description");

        String lienTableau[] = {pr.getLien() + "?but=compta/journal/journal-fiche.jsp"};
        String colonneLien[] = {"id"};
        String valLien[] = {"id"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setValeurLien(valLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setColonneLien(colonneLien);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("modifier",pr.getLien() + "?but=compta/journal/journal-saisie.jsp&acte=update");
        lienTab.put("dupliquer", pr.getLien() + "?but=compta/journal/journal-saisie.jsp&acte=dupliquer");
        pr.getTableau().setLienClicDroite(lienTab);

    %>
    <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="incident" id="incident">
            <%
               out.println(pr.getFormu().getHtmlEnsemble());
            %>
    </form>
    <%
            out.println(pr.getTableauRecap().getHtml());%>
    <br>
        <%
             String libEnteteAffiche[] = {"R&eacute;f.", "Code", "Description", "Compte"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% } %>
