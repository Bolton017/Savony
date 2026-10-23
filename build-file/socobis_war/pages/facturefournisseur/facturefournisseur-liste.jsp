<%-- 
    Document   : vente-liste
    Created on : 25 mars 2024, 09:57:03
    Author     : Angela
--%>

<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{
    FactureFournisseurCpl bc = new FactureFournisseurCpl();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};
    bc.setNomTable("FACTUREFOURNISSEURCPL_TOUS");
    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("FACTUREFOURNISSEURCPL_TOUS");
    }
    String listeCrt[] = {"id", "designation","daty", "dateEcheancePaiement", "montantttc", "montantpaye", "montantreste", "idFournisseurLib"};
    String listeInt[] = {"daty", "dateEcheancePaiement", "montantttc", "montantpaye", "montantreste"};
    String libEntete[] = {"id","designation","idFournisseurLib","idDevise","daty","montantttc","montantttcAr","montantPayeAr", "montantResteAr", "dateEcheancePaiement","etatlib"};
    String libEnteteAffiche[] = {"ID","D&eacute;signation","Fournisseur","devise","Date","Montant TTC","Montant TTC AR","Montant pay&eacute; AR","Montant Restant AR", "date d'&Eacute;ch&eacute;ance de Paiement","&Eacute;tat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }
    String paiement = "tous";
    if(request.getParameter("paiement")!=null && request.getParameter("paiement").compareToIgnoreCase("")!=0) {
        if(request.getParameter("paiement").compareToIgnoreCase("payer")==0){
            pr.setAWhere(pr.getAWhere()+" AND MONTANTRESTE=0 ");
            paiement = "payer";
        }else if(request.getParameter("paiement").compareToIgnoreCase("impayer")==0){
            pr.setAWhere(pr.getAWhere()+" AND MONTANTRESTE>0 ");
            paiement = "impayer";
        }
    }
    pr.getFormu().setOrdre(new String[] {"id", "designation","daty", "dateEcheancePaiement", "montantttc", "montantpaye", "montantreste", "idFournisseurLib",});

    pr.setTitre("Liste des factures fournisseurs");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facturefournisseur/facturefournisseur-liste.jsp");
    String[] colSomme = { "montantttcAr", "montantPayeAr", "montantResteAr" };
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idFournisseurLib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC Min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC Max");
    pr.getFormu().getChamp("montantreste1").setLibelle("Montant Restant Min");
    pr.getFormu().getChamp("montantreste2").setLibelle("Montant Restant Max");
    pr.getFormu().getChamp("montantpaye1").setLibelle("Montant Pay&eacute; Min");
    pr.getFormu().getChamp("montantpaye2").setLibelle("Montant Pay&eacute; Max");

    pr.getFormu().getChamp("dateEcheancePaiement1").setLibelle("Date d'&Eacute;ch&eacute;ance de paiement Min");
    pr.getFormu().getChamp("dateEcheancePaiement2").setLibelle("Date d'&Eacute;ch&eacute;ance de paiement Max");
    pr.getFormu().getChamp("dateEcheancePaiement1").setDefaut(Utilitaire.ajoutMoisDateString(utilitaire.Utilitaire.dateDuJourSql(),-12));
    pr.getFormu().getChamp("dateEcheancePaiement2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");

    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien

    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    lienTab.put("Modifier",pr.getLien() + "?but=facturefournisseur/facturefournisseur-modif.jsp");
    lienTab.put("Livrer",pr.getLien() + "?but=facturefournisseur/apresLivraisonFacture.jsp&id="+pr.getFormu().getChamp("id").getValeur() +"");
    String classe = "faturefournisseur.FactureFournisseur";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=facturefournisseur/facturefournisseur-liste.jsp&classe=" + classe+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=facturefournisseur/facturefournisseur-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp", pr.getLien() + "?but=bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id","idBc"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("facturefournisseur/inc/facture-fournisseur-liste-detail.jsp&id=");
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=facturefournisseur/facturefournisseur-saisie.jsp&currentMenu=MNDN000000014\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une facture fournisseur</a>"
    );
    

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
                String libelles[]={"", "Nombre","Somme des montants TTC AR", "Somme des montants pay&eacute;s AR", "Somme des montants restants AR" };
                pr.getTableauRecap().setLibeEntete(libelles);
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="row">
                    <div class="col-md-4">
                        Devise
                        <select name="devise" class="champ form-control" id="devise" onchange="changerDesignation()" >
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("FACTUREFOURNISSEURCPL_TOUS") == 0) {%>
                            <option value="FACTUREFOURNISSEURCPL_TOUS" selected>Tous</option>
                            <% } else { %>
                            <option value="FACTUREFOURNISSEURCPL_TOUS">Tous</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("FACTUREFOURNISSEURCPL_MGA") == 0) {%>
                            <option value="FACTUREFOURNISSEURCPL_MGA" selected>AR</option>
                            <% } else { %>
                            <option value="FACTUREFOURNISSEURCPL_MGA">AR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("FACTUREFOURNISSEURCPL_EUR") == 0) {%>
                            <option value="FACTUREFOURNISSEURCPL_EUR" selected>EUR</option>
                            <% } else { %>
                            <option value="FACTUREFOURNISSEURCPL_EUR">EUR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("FACTUREFOURNISSEURCPL_USD") == 0) {%>
                            <option value="FACTUREFOURNISSEURCPL_USD" selected>USD</option>
                            <% } else { %>
                            <option value="FACTUREFOURNISSEURCPL_USD">USD</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        &Eacute;tat
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        Paiement
                        <select name="paiement" class="champ form-control" id="paiement" onchange="changerDesignation()">
                            <%if(paiement.compareToIgnoreCase("tous")==0){%>
                            <option value="tous" selected> Tous </option>
                            <%}else{%>
                            <option value="tous"> Tous </option>
                            <%}%>

                            <%if(paiement.compareToIgnoreCase("payer")==0){%>
                            <option value="payer" selected> Pay&eacute;e(s) </option>
                            <%}else{%>
                            <option value="payer"> Pay&eacute;e(s) </option>
                            <%}%>

                            <%if(paiement.compareToIgnoreCase("impayer")==0){%>
                            <option value="impayer" selected> Impay&eacute;e(s) </option>
                            <%}else{%>
                            <option value="impayer"> Impay&eacute;e(s) </option>
                            <%}%>



                        </select>
                    </div>
                </div>
            </div>

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




