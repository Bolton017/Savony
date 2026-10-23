<%-- 
    Document   : vente-liste
    Created on : 25 mars 2024, 09:57:03
    Author     : Angela
--%>

<%@page import="vente.As_BondeLivraisonClientLib"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{ 
    As_BondeLivraisonClientLib blc = new As_BondeLivraisonClientLib();
    blc.setNomTable("BLC_NONfacture");
    String listeCrt[] = {"id", "remarque","magasinlib","daty","idClientLib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "remarque","magasinlib","daty", "idClientLib"};
    String libEnteteAffiche[] = {"id", "Remarque","Magasin","Date","Client"};
    PageRecherche pr = new PageRecherche(blc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de livraison non factur&eacute;s");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/bondelivraison-client/facturer-livraison.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("magasinlib").setLibelle("Magasin");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
   
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-modif.jsp"); 
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setAfficheBouttondevalider(false);
    pr.getTableau().setNameBoutton("Attacher BL");
%>
<script>
     function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="facture" id="facture">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form action="<%= pr.getLien() + "?but=vente/bondelivraison-client/apresFacturerLivraison.jsp"%>" method="post" >
            <% if(request.getParameter("idVente") != null)  { %>
                <input type="hidden" name="idVente" value="<%= request.getParameter("idVente") %>">
            <% } %>
            <input type="hidden" name="acte">
            <input type="hidden" name="bute" value="<%= pr.getLien() + "?but=vente/bondelivraison-client/facturer-livraison.jsp" %>">
            <%
                if(pr.getTableau().getHtmlWithCheckbox() != null) {
                    out.println(pr.getTableau().getHtmlWithCheckbox());
                }
            %>
        </form>
        <%
            if(pr.getBasPage() != null) {
                out.println(pr.getBasPage());
            }
        %>
    </section>
</div>
    <%
    }catch(Exception e){
        e.printStackTrace();
    }
%>




