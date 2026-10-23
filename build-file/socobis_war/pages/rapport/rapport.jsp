<%@ page import="rapport.mapping.CrDateFormu" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.sql.Date" %>
<%@ page import="rapport.Rapport" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% try{
        CrDateFormu crDateFormu = new CrDateFormu();
        String listeCrt[] = {"daty"};
        String listeInt[] = {};
        String libEntete[] = {};
        PageRecherche pr = new PageRecherche(crDateFormu, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Choisir une Date");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("rapport/rapport.jsp");
        pr.getFormu().getChamp("daty").setLibelle("Date");
        pr.getFormu().getChamp("daty").setType("date");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
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
    </section>
</div>
<%
        if(request.getParameter("daty")!=null){
            Date daty = Date.valueOf(request.getParameter("daty"));
            System.out.println(daty);
            System.out.println("Envoi----------");
            Rapport rapport = new Rapport();
            rapport.sendMailDate(daty, null);
            System.out.println("Termine----------");
        }
    }catch(Exception e){
        e.printStackTrace();
    }
%>