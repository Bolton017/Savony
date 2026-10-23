<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 17/09/2025
  Time: 15:11
  To change this template use File | Settings | File Templates.
--%>

<%@page import="paie.edition.TraitementPaie"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="paie.employe.ConstantePaie"%>

<% try {
  TraitementPaie tp = new TraitementPaie();
  tp.setNomTable("TRAITEMENTPAIE_CPL");
  if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
    tp.setNomTable(request.getParameter("etat"));
  }
  String listeCrt[] = {"modepaiement", "matricule", "moislib", "annee"};
  String listeInt[] = {};
  String libEntete[] = {"id", "idpersonnel", "nomPersonnel", "matricule", "numerocompte", "idedition", "modepaiementlib","netapayer","moislib","annee","etatlib"};
  PageRecherche pr = new PageRecherche(tp, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));


  affichage.Champ[] liste = new affichage.Champ[2];
  TypeObjet c = new TypeObjet();
  c.setNomTable("modepaiement");
  liste[0] = new Liste("modepaiement", c, "val", "id");
  TypeObjet[] mois = ConstantePaie.getMoisTous();
  liste[1] = new Liste("moislib", mois, "val", "val");

  pr.getFormu().changerEnChamp(liste);
  pr.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
  pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
  pr.getFormu().getChamp("moislib").setLibelle("Mois");

  String lienTableau[] = {pr.getLien() + "?but=paie/employe/traitementpaie-fiche.jsp"};
  String colonneLien[] = {"id"};

  pr.setApres("paie/employe/traitementpaie-liste.jsp");
  String[] colSomme = null;
//  pr.setNpp(1000);
  pr.creerObjetPage(libEntete, colSomme);

  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  String libEnteteAffiche[] = {"ID","Id du personnel","Nom du personnel","matricule","num&eacute;ro de compte","id &eacute;dition","mode de paiement","NET &agrave; payer","Mois","ann&eacute;e","&Eacute;tat"};
%>
<script>
  function changerDesignation() {
    document.dossierInscription.submit();
  }
</script>

<div class="content-wrapper">
  <section class="content-header">
    <h1>Liste des traitements de paie</h1>
  </section>
  <section class="content">
    <form action="<%=pr.getLien()%>?but=paie/employe/traitementpaie-liste.jsp" method="post" name="dossierInscription" id="dossierInscription">
      <% out.println(pr.getFormu().getHtmlEnsemble()); %>
      <div class="row col-md-12">
        <div class="col-md-4"></div>
        <div class="col-md-4">
          &Eacute;tat :
          <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
            <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TRAITEMENTPAIE_CPL") == 0) {%>
            <option value="TRAITEMENTPAIE_CPL" selected>Tous</option>
            <% } else { %>
            <option value="TRAITEMENTPAIE_CPL" >Tous</option>
            <% } %>
            <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TRAITEMENTPAIE_CPL_CREE") == 0) {%>
            <option value="TRAITEMENTPAIE_CPL_CREE" selected>Cr&eacute;e</option>
            <% } else { %>
            <option value="TRAITEMENTPAIE_CPL_CREE">Cr&eacute;&eacute;</option>
            <% } %>
            <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TRAITEMENTPAIE_CPL_VISEE") == 0) {%>
            <option value="TRAITEMENTPAIE_CPL_VISEE" selected>Valid&eacute;</option>
            <% } else { %>
            <option value="TRAITEMENTPAIE_CPL_VISEE">Valid&eacute;</option>
            <% } %>
          </select>
        </div>
        <div class="col-md-4"></div>
      </div>
    </form>
    <br>
    <br>

    <%
      out.println(pr.getTableauRecap().getHtml());%>
    <br>
    <%
      if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TRAITEMENTPAIE_CPL_CREE") == 0) {%>
    <form action="<%=pr.getLien()%>?but=apresMultiple.jsp" method="post" name="incident" id="incident">
      <input type="hidden" name="bute" value="paie/employe/traitementpaie-liste.jsp"/>
      <input type="hidden" name="classe" value="paie.edition.TraitementPaie"/>
      <input type="hidden" name="acte" value="validerMultiple"/>
      <%
        pr.getTableau().setNameActe("validerMultiple");
        pr.getTableau().setNameBoutton("Valider");
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        out.println(pr.getTableau().getHtmlWithCheckbox());
        out.println(pr.getBasPage());
      %>
    </form>
    <%
      } else {
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        out.println(pr.getTableau().getHtml());
        out.println(pr.getBasPage());
      }
    %>
  </section>
</div>

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>

