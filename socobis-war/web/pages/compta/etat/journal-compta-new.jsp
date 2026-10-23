<%--
    Document   : client-liste
    Created on : 22 mars 2024, 14:50:31
    Author     : SAFIDY
--%>

<%@page import="client.Client"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ComptaSousEcritureLibJournal" %>
<%@ page import="mg.cnaps.compta.JournalLib" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    ComptaSousEcritureLibJournal t = new ComptaSousEcritureLibJournal();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"idMere","jour","designationmere","daty", "compte", "debit","credit"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String journal = request.getParameter("journal");
    String mois = request.getParameter("mois");
    String annee = request.getParameter("annee");

    JournalLib temp = new JournalLib(journal, Integer.parseInt(mois),Integer.parseInt(annee));

    ComptaSousEcritureLibJournal [] detail = temp.getDetail();
    detail = temp.formaterData(detail);
    String moislib = Utilitaire.nbToMois(Integer.parseInt(mois));

    pr.setTitre("Journaux du " + moislib + " " + annee);

    pr.getTableau().setData(detail);

    String libEnteteAffiche[] = {"No Ecriture", "Jour", "D&eacute;signation", "Date" ,"Compte","D&eacute;bit","Cr&eacute;dit"};
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




