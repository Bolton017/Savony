<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="calculBesoin.CalculBesoinLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.Magasin" %>

<% try{ 
    CalculBesoinLib o = new CalculBesoinLib();
    o.setNomTable("CALCULBESOINLIB");
    String[] listeCrt = {"idMagasin","daty","designation"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","designation","idMagasinLib","etat"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des calculs de besoins");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("calculBesoin/calculBesoin-liste.jsp");
    
    Liste[] liste = new Liste[1];
    Magasin liste0 = new Magasin();
    liste0.setNomTable("MAGASIN2");
    liste[0] = new Liste("idMagasin",liste0,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("designation").setLibelle("Designation");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Daty","Designation","IdMagasinLib","Etat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=calculBesoin/calculBesoin-fiche.jsp"};
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

