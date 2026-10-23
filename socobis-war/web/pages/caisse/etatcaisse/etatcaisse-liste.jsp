<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>

<%@page import="caisse.EtatCaisse"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="caisse.TypeCaisse" %>
<%@ page import="annexe.Point" %>

<% try{
    EtatCaisse t = new EtatCaisse();
    t.setNomTable("V_ETATCAISSE");
    String listeCrt[] = {"idCaisselib","idPointlib","idTypeCaisselib","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"idCaisselib","idPointlib","idTypeCaisselib","dateDernierReport","montantDernierReport","credit","debit", "reste","taux","resteAr"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("&Eacute;tat de Caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/etatcaisse/etatcaisse-liste.jsp");

    Liste[] liste = new Liste[2];
    TypeCaisse type = new TypeCaisse();
    type.setNomTable("TYPECAISSE");
    liste[0] = new Liste("idTypeCaisseLib",type,"val","val");
    Point point = new Point();
    point.setNomTable("point");
    liste[1] = new Liste("idPointLib",point,"val","val");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("idCaisselib").setLibelle("Tr&eacute;sorerie");
    pr.getFormu().getChamp("idPointlib").setLibelle("Point");
    pr.getFormu().getChamp("idTypeCaisselib").setLibelle("Type de tr&eacute;sorerie");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut("01/01/2025");
    pr.getFormu().getChamp("daty1").setVisible(false);
    pr.getFormu().getChamp("daty2").setLibelle("Date");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = {"resteAr"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
/*    String lienTableau[] = {pr.getLien() + "?but=fiche/template-fiche-simple.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);*/
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"Tr&eacute;sorerie","Point","Type de Tr&eacute;sorerie","Date du dernier report","Solde initial","Entr&eacute;e","Sortie", "Solde Final","taux", "Solde Final MGA"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableauRecap().setLibeEntete(new String[]{"","Nombre","Somme des soldes finaux (MGA)"});
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
            out.println(pr.getTableauRecap().getHtml());%>
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



