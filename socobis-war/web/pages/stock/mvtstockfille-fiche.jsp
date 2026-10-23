<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="stock.MvtStockFilleLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    MvtStockFilleLib o = new MvtStockFilleLib();
    o.setNomTable("MVTSTOCKFILLELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche mouvement de stock d&eacute;tail");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idProduitlib").setLibelle("d&eacute;signation");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("mvtsrc").setLibelle("Source du mouvement");
    pc.getChampByName("libelle").setLibelle("Libell&eacute;");
    pc.getChampByName("dateSql").setLibelle("Date");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idMvtStock").setLibelle("Id mouvement stock");
    pc.getChampByName("idMvtStock").setLien(lien + "?but=stock/mvtstock-fiche.jsp", "id=");
    pc.getChampByName("idProduit").setLien(lien + "?but=produits/as-ingredients-fiche.jsp", "id=");
    pc.getChampByName("idProduit").setLibelle("Id produit");
    pc.getChampByName("entree").setLibelle("Entr&eacute;e");
    pc.getChampByName("sortie").setLibelle("Sortie");
    pc.getChampByName("pu").setLibelle("Prix unitaire");
    pc.getChampByName("montant").setLibelle("Montant");
    pc.getChampByName("mvtSrc").setLibelle("Source du mouvement");
    pc.getChampByName("idVenteDetaillib").setVisible(false);
    pc.getChampByName("mvtSrc").setVisible(false);
    pc.getChampByName("idTransfertDetaillib").setVisible(false);
    pc.getChampByName("libelleexacte").setVisible(false);
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idObjet").setVisible(false);
    pc.getChampByName("idLot").setVisible(false);
    pc.getChampByName("daty").setVisible(false);
    pc.getChampByName("idVenteDetail").setVisible(false);
    pc.getChampByName("idTransfertDetail").setVisible(false);

    String[] ordre = {"dateSql","idProduitlib","idMagasinLib","mvtsrc","libelle","id","idMvtStock","idProduit","entree","sortie","pu","montant","mvtSrc"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "stock/mvtstockfille-saisie.jsp&acte=update";
    String pageApresDelete = "stock/mvtstockfille-liste.jsp";
    String classe = "stock.MvtStockFilleLib";

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

<div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-6">
        <div class="box-fiche">
            <div class="box">
                <div class="box-body">
                    <%
                        out.println(pc.getHtml());
                    %>
                    <br/>
                   
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

