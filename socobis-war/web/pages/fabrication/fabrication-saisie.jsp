<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="fabrication.FabricationFille" %>
<%@ page import="fabrication.OfFilleCpl" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="vente.BonDeCommande" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%@ page import="fabrication.OfFille" %>
<%@ page import="machine.Machine" %>
<%
    try{
        UserEJB u = null;
        String idOffille = request.getParameter("idOffille");
        String typeAtelier = request.getParameter("typeAtelier");
        String raf = request.getParameter("raf");
        u = (UserEJB) session.getValue("u");
        Fabrication mere = new Fabrication();
        FabricationFille fille = new FabricationFille();
        FabricationFille[] fabfille = null;
        Fabrication prerempli = null;
        String titre = "Cr&eacute;ation d'une fabrication";
        String idBC = request.getParameter("idBC");
        if(idBC!= null && !idBC.isEmpty()){
            BonDeCommande comm = new BonDeCommande();
            comm.setId(idBC);
            fabfille = comm.getFabFille();
        }

        String idFab = request.getParameter("id");
        if(idFab!= null && !idFab.isEmpty()){
            titre = "Modification de Fabrication";
            fille.setIdMere(idFab);
        }

        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        FabricationFille[] fillesIA = (FabricationFille[])session.getAttribute("fillesIA");
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idOffille").setPageAppelComplete("fabrication.OfFilleCpl", "id", "OFFILLELIB");
        if(request.getParameter("idOffille") != null && !request.getParameter("idOffille").equalsIgnoreCase("")){
            idOffille = request.getParameter("idOffille");
            pi.getFormu().getChamp("idOffille").setDefaut(idOffille);
        }
        pi.getFormu().getChamp("idOffille").setLibelle(" Ordre de fabrication associ&eacute;");
        pi.getFormu().getChamp("lancePar").setPageAppelComplete("magasin.Magasin", "id", "MAGASINPOINT");
        pi.getFormu().getChamp("idBc").setLibelle("Bon de commande associ&eacute;");
        pi.getFormu().getChamp("equipe").setVisible(false);
        pi.getFormu().getChamp("estUnProjet").setVisible(false);


        if(idBC != "" && idBC != null){
            pi.getFormu().getChamp("idBc").setDefaut(idBC);
            if(fabfille!=null && fabfille.length > 0){
                pi.setDefautFille(fabfille);
                pi.getFormu().getChamp("libelle").setDefaut("Fabrication du BC "+idBC);
            }
        }
        if(request.getParameter("idOffille") != null && !request.getParameter("idOffille").equalsIgnoreCase("")){
            idOffille = request.getParameter("idOffille");
            pi.getFormu().getChamp("idOffille").setDefaut(idOffille);
            OfFille ofFille = new OfFille();
            ofFille.setId(idOffille);
            String unParUn = request.getParameter("unParUn");
            boolean proposerRaf = raf != null && raf.equalsIgnoreCase("true");
            if(Utilitaire.champNull(unParUn).isEmpty()){
                prerempli = ofFille.genererFabrication(typeAtelier, proposerRaf, null);
            }else{
                prerempli = ofFille.genererFabricationUnParUn(typeAtelier, proposerRaf, null);
            }


            fabfille = (FabricationFille[]) prerempli.getFille();

            if(fabfille!=null && fabfille.length > 0){
                pi.getFormu().setDefaut(prerempli);
                pi.setDefautFille(fabfille);
            }
        }

        pi.getFormu().getChamp("lanceur").setAutre("readonly");
        pi.getFormu().getChamp("lanceur").setDefaut(String.valueOf(u.getUser().getRefuser()));
        pi.getFormu().getChamp("cible").setLibelle("Cible");
        pi.getFormu().getChamp("cible").setPageAppelComplete("magasin.Magasin", "id", "MAGASINPOINT");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
        pi.getFormu().getChamp("besoin").setVisible(false);
        pi.getFormu().getChamp("idOf").setVisible(false);
        pi.getFormu().getChamp("fabricationSuiv").setVisible(false);
        pi.getFormu().getChamp("fabricationPrec").setVisible(false);

        Liste[] listeDeroulante=new Liste[2];
        listeDeroulante[0]=new Liste("lancePar",new bean.TypeObjet("MAGASINPOINT"),"val","id");
        listeDeroulante[1]=new Liste("cible",new bean.TypeObjet("MAGASINPOINT"),"val","id");

        pi.getFormu().changerEnChamp(listeDeroulante);
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute;e par");
        // pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("idbc").setVisible(false);
        pi.getFormu().setNbColonne(2);
        if(request.getParameter("designation")!=null)pi.getFormu().getChamp("libelle").setDefaut(request.getParameter("designation"));
        if(fillesIA!=null && fillesIA.length > 0){
            pi.setDefautFille(fillesIA);
        }
        session.removeAttribute("fillesIA");
        String[] order = {"daty"};
        pi.getFormu().setOrdre(order);
        pi.getFormufle().getChamp("idIngredients_0").setLibelle("Composants");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idunite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("idbcfille_0").setVisible(false);

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idMachine").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
//        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idbcfille").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("niveau").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("pu").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("operateur").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("nbPetris").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),"readonly");
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),false);
//        pi.getFormufle().getChamp("remarque_0").setTaille(20);
        //pi.getFormufle().getChamp("idMachine_0").setTaille(20);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "produits.IngredientsLib", "id", "as_ingredients_lib", "unite","idunite");
        String[] colOrdre = {"daty", "lancePar", "cible", "remarque", "libelle","idOffille","idOf","besoin","fabricationSuiv","fabricationPrec","etat"};
        pi.getFormu().setOrdre(colOrdre);
        String[] colOrdref = {"idIngredients","remarque", "qte", "idunite"};
        pi.getFormufle().setColOrdre(colOrdref);
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "fabrication.Fabrication";
        String classeFille = "fabrication.FabricationFille";
        String butApresPost = "fabrication/ordre-fabrication-details-fiche.jsp";
        if(idFab != null && !idFab.isEmpty()){
            butApresPost = "fabrication/fabrication-fiche.jsp&id="+idFab;
        }
        if(idOffille==null || idOffille.isEmpty()){
            butApresPost = "fabrication/fabrication-fiche.jsp";
        }
        String colonneMere = "idMere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1><%= titre %></h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
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

