<%@page import="java.sql.Connection"%>
²<%-- 
    Document   : classe-saisie.jsp
    Created on : 17 juin 2024, 15:32:16
    Author     : Mirado
--%>

<%@page import="faturefournisseur.*"%>
<%@page import="annexe.Unite"%>
<%@page import="magasin.Magasin"%>
<%@page import="vente.*"%>
<%@page import="user.*"%> 
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="annexe.Point" %>
<%@page import="utils.ConstanteSocobis"%>

<%
    try{
    String idbc = request.getParameter("idbc");
    String idbc_client = request.getParameter("idbc_client");
    String idfc_client = request.getParameter("idfc_client");
    String idbc_preparer = request.getParameter("idbc_preparer");
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    PageInsertMultiple pi=null;
    As_BondeLivraisonClient mere = new As_BondeLivraisonClient();   
    As_BondeLivraisonClientFilleInsertion fille = new As_BondeLivraisonClientFilleInsertion();
    int nombreLigne = 10;
    if(idfc_client != null && !idfc_client.trim().isEmpty()){
            Vente vt = new Vente();
            vt.setId(idfc_client);
            As_BondeLivraisonClient ld = vt.genererBonLivraison();
            if(ld!=null&&ld.getFille().length>10)nombreLigne=ld.getFille().length;
    }
    pi = new PageInsertMultiple(mere,fille,request, nombreLigne,u);
    As_BondeLivraisonClient livraisonDefaut = null;
    String[] ids = request.getParameterValues("id");
    if(idbc != null && !idbc.trim().isEmpty()){
        Carton b = new Carton();
        b.setId(idbc);
        Connection c = null;
        livraisonDefaut = b.genererLivraisonCarton(c, ids, idbc);
    }else if(idbc_client != null && !idbc_client.trim().isEmpty()){
        BonDeCommande b = new BonDeCommande();
        b.setId(idbc_client);
        livraisonDefaut = b.genererLivraison();
    }else if(idfc_client != null && !idfc_client.trim().isEmpty()){
        Vente v = new Vente();
        v.setId(idfc_client);
        livraisonDefaut = v.genererBonLivraison();
    }
    else if(idbc_preparer != null && !idbc_preparer.trim().isEmpty()){
        BonDeCommande b = new BonDeCommande();
        b.setId(idbc_preparer);
        livraisonDefaut = b.genererLivraison();
    }

    
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idbc").setAutre("readonly");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idVente").setLibelle("R&eacute;f&eacute;rence Vente");
    pi.getFormu().getChamp("idbc").setLibelle("R&eacute;f&eacute;rence Bon de commande");
    pi.getFormu().getChamp("idbc").setVisible(false);
    pi.getFormu().getChamp("idVente").setAutre("readonly");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idorigine").setVisible(false);
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("lieudelivraison").setLibelle("Lieu de livraison");
    pi.getFormu().getChamp("vehicule").setLibelle("Voiture");
    pi.getFormu().getChamp("chauffeur").setLibelle("&Eacute;quipe de livraison");
    pi.getFormu().getChamp("idClient").setLibelle("Client");
    pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
    affichage.Liste[] liste = new Liste[1];
        Magasin m = new Magasin();
        m.setNomTable("MAGASINVENTE");
    liste[0] = new Liste("magasin",m,"val","id");
    pi.getFormu().getChamp("magasin").setDefaut(ConstanteSocobis.MAGASIN);
    pi.getFormu().changerEnChamp(liste);
    affichage.Liste[] listed = new affichage.Liste[pi.getNombreLigne()];
    pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
    pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    for (int i = 0; i < pi.getNombreLigne(); i++) {

        pi.getFormufle().getChamp("id_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("unitelib_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("produitLib_0").setLibelle("Produit");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produitlib"),"annexe.ProduitLib","id","PRODUIT_LIB","id;idUniteLib;idUnite","produit;uniteLib;unite");


//        pi.getFormufle().getChamp("idventedetail_0").setLibelle("Vente");
    }
    String[] order_form = {"daty","idVente","magasin","idclient","etat","vehicule","chauffeur","idorigine","remarque"};
    pi.getFormu().setOrdre(order_form);
    
    
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("numbl"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("produit"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc_fille"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idventedetail"),false);

    if ((idbc != null && !idbc.trim().isEmpty()) || (idbc_client != null && !idbc_client.trim().isEmpty()) || (idfc_client != null && !idfc_client.trim().isEmpty()) || (idbc_preparer != null && !idbc_preparer.trim().isEmpty())) {
        pi.getFormu().setDefaut(livraisonDefaut);
        pi.setDefautFille(livraisonDefaut.getFille());
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
    }

    pi.preparerDataFormu();

    //Variables de navigation
    String classeMere = "vente.As_BondeLivraisonClient";
    String classeFille = "vente.As_BondeLivraisonClientFille";
    String butApresPost = "bondelivraison-client/bondelivraison-client-fiche.jsp";
    String colonneMere = "numbl";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
    String titre = "Saisie d'un bon de livraison";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un bon de livraison";
        }   
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


