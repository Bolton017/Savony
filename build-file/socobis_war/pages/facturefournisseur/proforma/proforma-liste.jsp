<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="caisse.Devise" %>
<%@ page import="faturefournisseur.ModePaiement" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    ProformaFournisseurLib o = new ProformaFournisseurLib();
    o.setNomTable("PROFORMAFOURNISSEUR_MERECPL");
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)", "Vis&eacute;e(s) par le PDG", "Annul&eacute;e(s)"};
    String[] listeCrt = {"id","designation","remarque","idDeviselib","daty","modepaiement","fournisseurlib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","designation","remarque","daty","fournisseurlib","idDeviselib","modepaiementlib","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des proformas");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facturefournisseur/proforma/proforma-liste.jsp");
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }
    Liste[] liste = new Liste[2];
    Devise liste0 = new Devise();
    liste0.setNomTable("DEVISE");
    liste[0] = new Liste("idDeviselib",liste0,"val","id");
    ModePaiement liste1 = new ModePaiement();
    liste1.setNomTable("MODEPAIEMENT");
    liste[1] = new Liste("modepaiement",liste1,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idDeviselib").setLibelle("Devise");
    pr.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");

    String[] colSomme = {"montantTVA","montantHT","montantTTC","montantTTCARIARY"};
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    String classe = "faturefournisseur.proforma.ProformaFournisseur";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=facturefournisseur/proforma/proforma-liste.jsp&classe=" + classe+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=facturefournisseur/proforma/proforma-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/proforma/proforma-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("facturefournisseur/proforma/inc/proforma-liste-detail.jsp&id=");

    String[] enteteRecap = {"","Nombre","Somme de la TVA","Somme des montants HT","Somme des montants TTC","Somme des montants TTC en ariary"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Id","D&eacute;signation","Remarque","Date","Fournisseur","Devise","Mode de paiement","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);


%>
<script>
    function changerDesignation() {
        document.getElementById("bc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 noppadding">
                <div class="col-md-2 noppadding">
                    &Eacute;tat :
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
            </div>
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

