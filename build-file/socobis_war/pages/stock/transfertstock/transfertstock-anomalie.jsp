<%@page import="stock.TransfertStockCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="prevision.Service" %>

<%
try{
    TransfertStockCpl stock = new TransfertStockCpl();
    stock.setNomTable("transfertStockAnomalie");

    String listeCrt[] = {"id","designation","idMagasinDepart","idMagasinArrive","idDepartementDepart","idDepartementArrive","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","designation","idMagasinDepartlib","idMagasinArrivelib","idDepartementLibDepart", "idDepartementLibArrive","etatlib"};

    PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des transferts de stock avec anomalies");

    Liste[] listes = new Liste[4];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");

    listes[0] = new Liste("idMagasinDepart", m, "val", "id");
    listes[1] = new Liste("idMagasinArrive", m, "val", "id");
    listes[2] = new Liste("idDepartementDepart", new Service(), "libelle", "id");
    listes[3] = new Liste("idDepartementArrive", new Service(), "libelle", "id");

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/transfertstock/transfertstock-anomalie.jsp");

    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("id").setLibelle("Ref");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasinDepart").setLibelle("Magasin de d&eacute;part");
    pr.getFormu().getChamp("idMagasinArrive").setLibelle("Magasin d'arriv&eacute;e");
    pr.getFormu().getChamp("idDepartementDepart").setLibelle("D&eacute;partement de d&eacute;part");
    pr.getFormu().getChamp("idDepartementArrive").setLibelle("D&eacute;partement d'arriv&eacute;e");

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());

    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=stock/transfertstock/transfertstock-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=stock/transfertstock/transfertstock-fiche.jsp"};
    String colonneLien[] = {"id"};

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("stock/transfertstock/inc/transfertstockdetails-liste.jsp&id=");
    String libEnteteAffiche[] = {"Ref","date","D&eacute;signation","Magasin de d&eacute;part","Magasin d'arriv&eacute;e","D&eacute;partement de d&eacute;part", "D&eacute;partement d'arriv&eacute;e","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>

    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <%
            out.println(pr.getTableauRecap().getHtml());
        %>

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