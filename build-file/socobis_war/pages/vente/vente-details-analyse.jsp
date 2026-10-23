<%-- 
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>

<%
try{    
    VenteDetailsLib mvt = new VenteDetailsLib();
    String nomTable = "VENTE_DETAILS_POIDS";
    mvt.setNomTable(nomTable);
    
    String listeCrt[] = {"id","daty","idDeviseLib","categorieproduitlib","idclientlib"};
    String listeInt[] = {"daty"};
    String[] pourcentage = {};
    String[] colGr = {"categorieproduitlib","idProduitLib"};
    String[] colGrCol = {"idclientlib"};
//    String somDefaut[] = {"qte", "puTotal", "puRevient"};
    String somDefaut[] = {"qte", "puTotal"};
    
    PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, 2 , somDefaut.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String apreswhere = "";
    String debutSem=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
    if(request.getParameter("daty1")==null&&request.getParameter("daty2")==null)
    apreswhere= "and daty >= TO_DATE('"+debutSem+"','DD/MM/YYYY') and daty <= TO_DATE('"+utilitaire.Utilitaire.dateDuJour()+"','DD/MM/YYYY')";
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);
    String order = "";
    if(request.getParameter("order")!=null && request.getParameter("order").compareToIgnoreCase("")!=0){
        order+= (" "+ request.getParameter("order"));
    }
    String[] grouper = new String[1];
    if(request.getParameter("grouper")!=null && request.getParameter("grouper").compareToIgnoreCase("")!=0){
        grouper[0]=request.getParameter("grouper");
        pr.setColGroupeDefaut(grouper);
    }
    pr.setOrdre(order);
    pr.setAWhere(apreswhere);
    pr.getFormu().getChamp("daty1").setDefaut(debutSem);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("categorieproduitlib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idDeviseLib").setLibelle("Devise");
     pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.setNpp(500);
    pr.setApres("vente/vente-details-analyse.jsp");
    pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=");
    String libEnteteAffiche[] = {"ID","Id Vente","Id Produit","Origine","Quantit&eacute;","Prix unitaire","Remise","Tva","Prix achat","Prix vente","Devise","Taux de change","D&eacute;signation","Compte","Prix de revient","ID Bon de commande d&eacute;tail","ID Unit&eacute;","Unit&eacute;","Prix net","Montant ht","Montant ttc","Montant tva","Montant remise","Montant","Poids","Reste","Frais","Produit","Date","Date pr&eacute;visionnelle d'encaissement","Devise","Cat&eacute;gorie produit","Cat&eacute;gorie produit","Prix total","Client"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Statistiques des ventes d&eacute;taill&eacute;</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=vente/vente-details-analyse.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li>La premi&egrave;re ligne correspond &agrave; la quantit&eacute;</li>
            <li>La deuxi&egrave;me ligne correspond au montant total</li>
        </ul>
           <%

            String lienTableau[] = {};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(somDefaut);%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>