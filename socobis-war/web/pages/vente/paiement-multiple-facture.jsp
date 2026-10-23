<%--
    Document   : vente-liste
    Created on : 25 mars 2024, 09:57:03
    Author     : Angela
--%>

<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>

<% try{
    VenteLib bc = new VenteLib();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};

    String[] paiementVal = {"","1","0", "-1"};
    String[] paiementAff = {"Tous","Pay&eacute;e(s)", "Impay&eacute;e(s)", "Avec avoir"};

    String[] livraisonVal = {"","0","1"};
    String[] livraisonAff = {"Tous","Livr&eacute;e(s)", "Non Livr&eacute;e(s)"};
    bc.setNomTable("VENTE_CPL");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));





    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("VENTE_CPL");
    }
    String[] listeCrt = {"id", "designation","idClientLib","referencefacture","daty","datyprevu","montantttc","montantpaye","montantreste"};
    String[] listeInt = {"daty", "datyprevu","montantttc","montantpaye","montantreste"};
    String[] libEntete = {"id", "daty","datyprevu","designation","idClientLib","idDevise","referencefacture","montantttc","montantpaye", "montantreste","etatlib"};
    String[] libEnteteAffiche = {"Ref", "Date", "Date &Eacute;ch&eacute;ance","D&eacute;signation","Client","devise","R&eacute;f&eacute;rence facture","Montant TTC","Montant Pay&eacute;","Montant restant","&Eacute;tat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    pr.setAWhere(" and etat>= 11 and montantreste > 0");
    if(request.getParameter("paiement")!=null && request.getParameter("paiement").compareToIgnoreCase("")!=0) {
        if(request.getParameter("paiement").compareToIgnoreCase("0")==0){
            pr.setAWhere(pr.getAWhere()+" and montantreste>0");
        } else if(request.getParameter("paiement").compareToIgnoreCase("1")==0){
            pr.setAWhere(pr.getAWhere()+" and montantreste=0");
        }else if(request.getParameter("paiement").compareToIgnoreCase("-1")==0){
            pr.setAWhere(pr.getAWhere()+" and montantreste<0");
        }
    }
    if(request.getParameter("livraison")!=null && request.getParameter("livraison").compareToIgnoreCase("")!=0) {
        if(request.getParameter("livraison").compareToIgnoreCase("0")==0){
            pr.setAWhere(pr.getAWhere()+" and reste=0");
        } else if(request.getParameter("livraison").compareToIgnoreCase("1")==0){
            pr.setAWhere(pr.getAWhere()+" and reste>0");
        }
    }
    pr.setTitre("Paiement multiple des factures ventes");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/paiement-multiple-facture.jsp");
    String[] colSomme = { "montantttc", "montantpaye", "montantreste" };
    pr.getFormu().getChamp("id").setLibelle("Ref");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("referencefacture").setLibelle("R&eacute;f&eacute;rence facture");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("datyprevu1").setLibelle("Date d'&Eacute;ch&eacute;ance Min");
    pr.getFormu().getChamp("datyprevu2").setLibelle("Date d'&Eacute;ch&eacute;ance Max");
    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC Min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC Max");
    pr.getFormu().getChamp("montantpaye1").setLibelle("Montant pay&eacute; Min");
    pr.getFormu().getChamp("montantpaye2").setLibelle("Montant pay&eacute; Max");
    pr.getFormu().getChamp("montantreste1").setLibelle("Montant Restant Min");
    pr.getFormu().getChamp("montantreste2").setLibelle("Montant Restant Max");

    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
    pr.getFormu().setOrdre(new String[]{"id","daty1", "daty2","designation", "idClientLib", "referencefacture", "datyprevu1", "datyprevu2", "montantttc1", "montantttc2", "montantpaye1", "montantpaye2", "montantreste1", "montantreste2"});



    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/vente-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?&classe=vente.Vente&but=apresTarif.jsp&bute=vente/vente-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Livrer",pr.getLien() + "?but=bondelivraison-client/apresLivraisonFacture.jsp&bute=vente/encaissement-modif.jsp" + pr.getFormu().getChamp("id").getValeur()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] enteteRecap = {"","Nombre","Somme des montants TTC","Somme des montants pay&eacute;s","Somme des montants restants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
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
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="row">
                    <div class="col-md-4">
                        Livraison :
                        <select name="livraison" class="champ form-control" id="livraison" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < livraisonAff.length; i++ ){ %>
                            <% if(request.getParameter("livraison") !=null && request.getParameter("livraison").compareToIgnoreCase(livraisonVal[i]) == 0) {%>
                            <option value="<%= livraisonVal[i] %>" selected> <%= livraisonAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= livraisonVal[i] %>"> <%= livraisonAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                </div>
                </br>
            </div>

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
          <form action="<%=pr.getLien()%>?but=caisse/mvt/mvtCaisse-saisie-entree.jsp" method="post" name="facturevente" id="facturevente">
        <%
            if (pr.getTableau().getHtmlWithCheckbox() != null && !pr.getTableau().getHtmlWithCheckbox().isEmpty()){
                out.println(pr.getTableau().getHtmlWithCheckbox());
            } else {
        %>
                <h2 class="no-data-msg" style="margin-left:0">Aucune donn&eacute;e disponible</h2>
        <%
                }
        %>
        </form>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




