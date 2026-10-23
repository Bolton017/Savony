<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="analyse.AnalyseCpl" %>

<% try{ 
    AnalyseCpl o = new AnalyseCpl();
    o.setNomTable("ANALYSECPL");
    String[] listeCrt = {"idfabricationlib","idcriterelib","idresponsablelib","daty","id"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","idfabricationlib","idcriterelib","idresponsablelib","valeur","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des analyses");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("analyse/analyse-liste.jsp");
    pr.getFormu().getChamp("idfabricationlib").setLibelle("Fabrication");
    pr.getFormu().getChamp("idcriterelib").setLibelle("Crit&egrave;re");
    pr.getFormu().getChamp("idresponsablelib").setLibelle("Responsable");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("id").setLibelle("Id");
    
    String[] colSomme = {"valeur"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme de valeur"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Identifiant","Date","Fabrication","Crit&egrave;re","Responsable","Valeur","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=analyse/analyse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

