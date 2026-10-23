<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="maintenance.travaux.*" %>
<%
  try{
    UserEJB u = null;
    String idOffille = request.getParameter("idOffille");
    u = (UserEJB) session.getValue("u");
    Travaux mere = new Travaux();
    String nomtable = "Travaux";
    TravauxFille fille = new TravauxFille();
    TravauxFille [] fabfille = null;
    Fabrication prerempli = null;
    String titre = "Saisie de travaux";
    String idBC = request.getParameter("idBC");

    String idFab = request.getParameter("id");
    if(idFab!= null && !idFab.isEmpty()){
      titre = "Modification de travaux";
      fille.setIdMere(idFab);
    }

    int nombreLigne = 10;
    PageInsert pi = new PageInsert(mere, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idOffille").setPageAppelComplete("maintenance.travaux.OrdreTravauxFilleCpl", "id", "ORDRETRAVAUXFILLELIB");
    if(request.getParameter("idOffille") != null && !request.getParameter("idOffille").equalsIgnoreCase("")){
      idOffille = request.getParameter("idOffille");
      pi.getFormu().getChamp("idOffille").setDefaut(idOffille);
      OrdreTravauxFilleCpl ordreTravauxFilleCpl = new OrdreTravauxFilleCpl();
      ordreTravauxFilleCpl = (OrdreTravauxFilleCpl) ordreTravauxFilleCpl.getById(idOffille, "ORDRETRAVAUXFILLELIB", null);
      OrdreTravaux ordreTravauxMere = new OrdreTravaux();
      ordreTravauxMere = (OrdreTravaux) ordreTravauxMere.getById(ordreTravauxFilleCpl.getIdMere(), "ORDRETRAVAUX", null);
      pi.getFormu().getChamp("lancePar").setDefaut(ordreTravauxMere.getLancePar());
      pi.getFormu().getChamp("remarque").setDefaut(ordreTravauxMere.getRemarque());
      pi.getFormu().getChamp("libelle").setDefaut("Travaux pour l'element "+ordreTravauxFilleCpl.getLibelle());
      TravauxFille [] travauxFilles = new TravauxFille[1];
      travauxFilles[0] = new TravauxFille();
      travauxFilles[0].setIdIngredients(ordreTravauxFilleCpl.getIdIngredients());
      travauxFilles[0].setRemarque(ordreTravauxFilleCpl.getLibelleexacte());
//      pi.setDefautFille(travauxFilles);
    }

    pi.getFormu().getChamp("idOffille").setLibelle(" Ordre de travaux associ&eacute;");
    pi.getFormu().getChamp("lancePar").setPageAppelComplete("annexe.Entite", "id", "Entite");
    pi.getFormu().getChamp("idBc").setLibelle("Bon de commande associ&eacute;");
    pi.getFormu().getChamp("idBc").setVisible(false);
    pi.getFormu().getChamp("equipe").setLibelle("&Eacute;quipe");
    pi.getFormu().getChamp("dureeEstimatif").setLibelle("Dur&eacute;e estimative");
    pi.getFormu().getChamp("equipe").setVisible(false);
    pi.getFormu().getChamp("idOffille").setVisible(false);



    if(idBC != "" && idBC != null){
      pi.getFormu().getChamp("idBc").setDefaut(idBC);
      if(fabfille!=null && fabfille.length > 0){
//        pi.setDefautFille(fabfille);
        pi.getFormu().getChamp("libelle").setDefaut("Fabrication du BC "+idBC);
      }
    }
    if(request.getParameter("idOffille") != null && !request.getParameter("idOffille").equalsIgnoreCase("")){
      idOffille = request.getParameter("idOffille");
      pi.getFormu().getChamp("idOffille").setDefaut(idOffille);
      OrdreTravauxFille ofFille = new OrdreTravauxFille();
      ofFille.setId(idOffille);
      String unParUn = request.getParameter("unParUn");

      if(fabfille!=null && fabfille.length > 0){
        pi.getFormu().setDefaut(prerempli);
//        pi.setDefautFille(fabfille);
      }
    }

    pi.getFormu().getChamp("cible").setLibelle("Cible");
    pi.getFormu().getChamp("cible").setVisible(false);
    pi.getFormu().getChamp("remarque").setLibelle("Description");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
    pi.getFormu().getChamp("besoin").setVisible(false);
    pi.getFormu().getChamp("idOf").setVisible(false);
    pi.getFormu().getChamp("fabricationSuiv").setVisible(false);
    pi.getFormu().getChamp("fabricationPrec").setVisible(false);

    Liste[] listeDeroulante=new Liste[1];
    listeDeroulante[0]=new Liste("lancePar",new bean.TypeObjet("Entite"),"val","id");

    pi.getFormu().changerEnChamp(listeDeroulante);
    pi.getFormu().getChamp("lancePar").setLibelle("Entit&eacute;");
    // pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("idbc").setPageAppelComplete("vente.BonDeCommande", "id", "BONDECOMMANDE_CLIENT");
    pi.getFormu().setNbColonne(2);
    if(request.getParameter("designation")!=null)pi.getFormu().getChamp("libelle").setDefaut(request.getParameter("designation"));
    String[] order = {"daty"};
    pi.getFormu().setOrdre(order);
//    pi.getFormufle().getChamp("idIngredients_0").setLibelle("Machine");
//    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
//    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
//    pi.getFormufle().getChamp("idunite_0").setLibelle("Unit&eacute;");
//    pi.getFormufle().getChamp("idbcfille_0").setLibelle("Bon de commande fille");
//    pi.getFormufle().getChamp("operateur_0").setLibelle("Op&eacute;rateur");
//
//    pi.getFormufle().getChamp("idMachine_0").setLibelle("Machine");
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idMachine").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("unite").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("niveau").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("pu").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("nbPetris").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idbcfille").getListeChamp(),false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("qte").getListeChamp(),false);
//    affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("qte").getListeChamp(),"1");
//    affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),"readonly");
//    affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),"readonly");
//
////    afenina ny machine fa atao machine iray par defaut
//    pi.getFormufle().getChamp("idIngredients_0").setVisible(false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(),false);
//    pi.getFormufle().getChamp("remarque_0").setTaille(20);
//    pi.getFormufle().getChamp("idMachine_0").setTaille(20);
//    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");

    String idDepartement = request.getParameter("idDepartement");
    if (idDepartement == null || idDepartement.equals("")){
      idDepartement = "";
    } 
//    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampMulitple("operateur").getListeChamp(), "personnel.Personnel", "id", "PERSONNEL","",""," and idDepartement like '%"+idDepartement+"%'");
    String[] colOrdre = {"daty", "lancePar", "cible", "remarque", "libelle", "idbc","idOffille","idOf","besoin","fabricationSuiv","fabricationPrec","etat"};
    pi.getFormu().setOrdre(colOrdre);

    pi.preparerDataFormu();

    //Variables de navigation
    String classeMere = "maintenance.travaux.Travaux";
    String classeFille = "maintenance.travaux.TravauxFille";
    String butApresPost = "maintenance/travaux/Travaux-fiche.jsp";
    if(idFab != null && !idFab.isEmpty()){
      butApresPost = "maintenance/travaux/Travaux-fiche.jsp&id="+idFab;
    }
    if(idOffille==null || idOffille.isEmpty()){
      butApresPost = "maintenance/travaux/Travaux-fiche.jsp";
    }
    String colonneMere = "idMere";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
//    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
  <h1><%= titre %></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%

      out.println(pi.getFormu().getHtmlInsert());
//      out.println(pi.getFormufle().getHtmlTableauInsert());
    %>

    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
    <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
    <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
    <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">

  </form>

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

