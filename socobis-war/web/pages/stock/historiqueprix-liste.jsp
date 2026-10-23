<%@page import="stock.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    HistoriquePrixLib t = new HistoriquePrixLib();
    t.setNomTable("HistoriquePrixLib");
    String listeCrt[] = {"id","produit","daty", "idFacturefournisseurfille"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"daty","idProduit","produit","pv","remarque"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(request.getParameter("idFFD") != null){
        pr.setAWhere(" and IDFACTUREFOURNISSEURFILLE='"+request.getParameter("idFFD")+"'");
    }
    pr.setTitre("Historique des prix");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/historiqueprix-liste.jsp");

    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idFacturefournisseurfille").setLibelle("ID Facture");

    String[] colSomme = {};
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idProduit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"Date","ID Produit","Produit","Prix de vente","Remarque"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><div style="text-align: center;"><h4>Aucune donnée trouv&eacute;e</h4></div><%
    }
%>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



