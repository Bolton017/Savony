<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="stock.AnomalieTransfert" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.MagasinLib" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="prevision.Service" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    AnomalieTransfert o = new AnomalieTransfert();
    o.setNomTable("ANOMALIETRANSFERT");
    String[] listeCrt = {"daty","idProduitLib","idDepartementDepart", "idDepartementArrive","magasinDepart","magasinArrive"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idTransfert","daty","magasinDepartLib","magasinArriveLib","idDepartementLibDepart", "idDepartementLibArrive","designation","idProduitLib","quantite", "pu","montant","envoye","recu","ecart","montantEcart","reste"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des anomalies des transferts de stock");
    pr.setNpp(50);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/transfertstock/anomalie-liste.jsp");

    Liste[] liste = new Liste[4];
    liste[0] = new Liste( "magasinDepart", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
    liste[1] = new Liste( "magasinArrive", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
    TypeObjet dep = new TypeObjet("DEPARTEMENT");
    liste[2] = new Liste( "idDepartementDepart", dep, "val", "id");
    liste[2].setDeroulanteDependante(liste[0], "idDirection", "onchange");
    liste[3] = new Liste( "idDepartementArrive", dep, "val", "id");
    liste[3].setDeroulanteDependante(liste[1], "idDirection", "onchange");

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutSemaineString());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.getFinSemaineString());
    pr.getFormu().getChamp("magasinDepart").setLibelle("Magasin de d&eacutepart");
    pr.getFormu().getChamp("magasinArrive").setLibelle("Magasin d'arriv&eacutee");
    pr.getFormu().getChamp("idDepartementDepart").setLibelle("D&eacute;partement de d&eacute;part");
    pr.getFormu().getChamp("idDepartementArrive").setLibelle("D&eacute;partement d'arriv&eacute;e");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");

    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());

    String[] colSomme = {"envoye","recu","ecart","montantEcart","reste"};
    pr.creerObjetPage(libEntete, colSomme);

    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute; envoy&eacute;","Somme des quantit&eacute; re&ccedil;u","Somme des &eacute;carts en quantit&eacute;","Somme des &eacute;carts en montant","Somme des quantit&eacute; reste &agrave; envoyer"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=stock/transfertstock/transfertstock-fiche.jsp"};
    String[] colonneLien = {"idTransfert"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Ref Transfert","Date","Magasin d&eacute;part","Magasin arriv&eacute;e","D&eacute;partement de d&eacute;part", "D&eacute;partement d'arriv&eacute;e","Designation","Produit","Quantit&eacute; ", "PU","Montant","Envoy&eacute;","Re&ccedil;u","Ecart","Montant ecart","Reste &agrave; envoyer  "};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("stock/transfertstock/inc/transfertstockdetails-liste.jsp&id=");
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
<%--<script>--%>
<%--    var tousOption = document.querySelector('#idDepartementDepart option[value="%"]');--%>
<%--    if (tousOption) {--%>
<%--        tousOption.remove();--%>
<%--    }--%>

<%--    var tousOption2 = document.querySelector('#idDepartementArrive option[value="%"]');--%>
<%--    if (tousOption2) {--%>
<%--        tousOption2.remove();--%>
<%--    }--%>
<%--</script>--%>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

