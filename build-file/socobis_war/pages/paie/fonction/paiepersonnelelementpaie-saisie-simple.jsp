<%@page import="paie.elementpaie.PaiePersonnelElementpaie"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%
  try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.elementpaie.PaiePersonnelElementpaie",
            nomtable = "paie_personnel_elementpaie",
            apres = "paie/fonction/paiepersonnelelementpaie-liste.jsp",
            titre = "Saisie &eacute;lement de paie par personnel ";

    PaiePersonnelElementpaie  objet = new PaiePersonnelElementpaie();
    objet.setNomTable(nomtable);
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));

    affichage.Champ[] liste = new affichage.Champ[1];
    Liste mois = new Liste("moisregularisation");
    mois.makeListeMois();
    liste[0] = mois;
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","log_personnel_infocomplet");
    pi.getFormu().getChamp("code_rubrique").setPageAppelComplete("paie.employe.PaieRubrique","id","paie_rubrique");

    pi.getFormu().getChamp("pourcentage").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("unite").setVisible(false);
    pi.getFormu().getChamp("anneeregularisation").setDefaut(Utilitaire.getAnneeEnCours());

    pi.getFormu().getChamp("date_fin").setLibelle("Date de fin");
    pi.getFormu().getChamp("date_debut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("code_rubrique").setLibelle("Rubrique");
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");

    pi.getFormu().getChamp("id_objet").setVisible(false);
    pi.getFormu().getChamp("quantite").setVisible(false);

    pi.getFormu().getChamp("idcategorie_qualification").setVisible(false);
    pi.getFormu().getChamp("idfonction").setVisible(false);

    pi.getFormu().getChamp("moisregularisation").setLibelle("Mois");
    pi.getFormu().getChamp("anneeregularisation").setLibelle("ann&eacute;e de r&eacute;gularisation");
    pi.getFormu().getChamp("gain").setLibelle("Montant");
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("retenue").setVisible(false);
    
    String[] colOrdre = {
            "idpersonnel",
            "code_rubrique",
            "date_debut",
            "date_fin",
            "moisregularisation",
            "anneeregularisation",
            "gain",
    };

    pi.getFormu().setOrdre(colOrdre);

    pi.preparerDataFormu();
%>
<div class="content-wrapper">
  <h1> <%=titre%></h1>

  <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
      pi.getFormu().makeHtmlInsertTabIndex();
      out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
  </form>
</div>
<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();</script>
<% }%>

