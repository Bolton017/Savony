<%@page import="magasin.TypeMagasin"%>
<%@page import="magasin.MagasinNormal"%>
<%@page import="magasin.MagasinReservoir"%>
<%@page import="magasin.Magasin"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
  
    PageInsert pi =null;
    Liste[] liste = null;
    String titre = "Saisie d'un";
    if(request.getParameter("acte")!=null){
        titre = "Modification de magasin";
    }
    String classe = "magasin.MagasinNormal";

    
    if(request.getParameter("typemagasin") != null && request.getParameter("typemagasin").compareToIgnoreCase("reservoir") == 0){
        MagasinReservoir a = new MagasinReservoir();
        pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idTypeMagasin").setVisible(false);
        liste = new Liste[1];
        TypeObjet point = new TypeObjet();
        point.setNomTable("point");    
        liste[0] = new Liste("idPoint", point, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        titre = "R&eacute;servoir";
        pi.getFormu().getChamp("idProduit").setLibelle("Produit");
        //pi.getFormu().getChamp("idProduit").setAutocompleteDynamique("annexe.Produit","val", "id","Produit");
        pi.getFormu().getChamp("idProduit").setPageAppelComplete("annexe.Produit", "id","Produit");
        pi.getFormu().getChamp("idProduit").setPageAppelInsert("popup/produit/produit-popup.jsp","idProduit;idProduitlibelle","id;val");
        //pi.getFormu().getChamp("idProduit").setPageAppel("choix/produit/produit-choix.jsp");
        classe = "magasin.MagasinReservoir";
 
    }else{
        Magasin a = new Magasin();
        a.setNomTable("magasin2");
        pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        liste = new Liste[4];
        TypeObjet point = new TypeObjet();
        point.setNomTable("point");    
        liste[0] = new Liste("idPoint", point, "val", "id");
        TypeMagasin type=new TypeMagasin();
        type.setNomTable("typemagasin_sansreservoir");
        liste[1] = new Liste("idTypeMagasin", type, "val", "id");
        liste[2] = new Liste("idMagasinMere", a, "val", "id");
        liste[3] = new Liste("isVente");
        liste[3].makeListeOuiNon();
        liste[2].ajouterValeur(new String[]{""}, new String[]{"-"});
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idTypeMagasin").setLibelle("Type magasin");
        pi.getFormu().getChamp("isVente").setLibelle("Est vente");
        pi.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
        pi.getFormu().getChamp("idDepartement").setPageAppelComplete("prevision.Service", "id", "SERVICE");
        pi.getFormu().getChamp("idProduit").setVisible(false);
        pi.getFormu().getChamp("compteur").setVisible(false);
        classe = "magasin.Magasin";
    }

    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("D&eacute;scription");
    pi.getFormu().getChamp("idPoint").setLibelle("Point");
    pi.getFormu().getChamp("capacite").setLibelle("Capacit&eacute;");
    pi.getFormu().getChamp("idMagasinMere").setLibelle("Magasin d'origine");

  

    

   

    String butApresPost = "magasin/magasin-fiche.jsp";
    String nomTable = "magasin2";
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center"><%=titre%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>
