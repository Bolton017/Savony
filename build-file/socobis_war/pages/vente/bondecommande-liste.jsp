<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.Utilitaire" %>


<% try{
    BonDeCommandeCpl bdc = new BonDeCommandeCpl();
    String nomTable = "BONDECOMMANDE_CLIENT_CPL";
        if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("etat");
        }
       bdc.setNomTable(nomTable);
    String listeCrt[] = {"id","daty","designation","reference","idclientlib","idMagasinLib","idDevise","modepaiement","montantTTC","remarque"};
    String listeInt[] = {"daty","montantTTC"};
    String libEntete[] = {"id","daty","designation","reference","idclientlib","idMagasinLib","modepaiementlib","idDevise","montantTTC","montantTtcAr","remarque","etatlib","etatFacturation"};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de commande client");
     
    // Changer en Liste
    // Initialisation Liste

    Liste[] liste = new Liste[2];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiement",mp,"val","id");

    Magasin m = new Magasin();
    m.setNomTable("MAGASINVENTE");
    liste[1] = new Liste("idMagasinLib",m,"val","val");

    pr.getFormu().changerEnChamp(liste);

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/bondecommande-liste.jsp");

    pr.getFormu().getChamp("id").setLibelle("Ref.");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC max");
    pr.getFormu().getChamp("idDevise").setLibelle("Devise");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("reference").setLibelle("r&eacute;f&eacute;rence");
     pr.getFormu().getChamp("modepaiement").setLibelle("Mode de  paiement");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    //  pr.getFormu().getChamp("daty").setLibelle("daty");

    if(request.getParameter("id")!=null && request.getParameter("id").compareToIgnoreCase("")!=0) {
        pr.getFormu().getChamp("id").setDefaut(request.getParameter("id"));
    }
    if(request.getParameter("etaty")!=null && request.getParameter("etaty").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat>=" + request.getParameter("etaty"));
    }


    String[] colSomme = {"montantTtcAr"};
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String classe = "vente.BonDeCommande";
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=vente/bondecommande-liste.jsp&classe=" + classe+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=vente/bondecommande/bondecommande-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};    
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("vente/bondecommande/inc/bondecommande-detail.jsp&id=");
//    pr.getTableau().setLienFille("bondecommande/inc/bondecommande-liste-detail.jsp&id=");
    String libEnteteAffiche[] = {"Ref.","Date","D&eacute;signation","r&eacute;f&eacute;rence","Client","Magasin","Mode de paiement","devise","Montant TTC","Montant TTC (AR)","remarque","&Eacute;tat","&Eacute;tat facturation"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableauRecap().setLibeEntete(new String[] {"", "nombre", "Somme des montants TTC en Ariary"});
    String[] etatVal = {"BONDECOMMANDE_CLIENT_CPL","BONDECOMMANDE_CLIENT_CPL_C","BONDECOMMANDE_CLIENT_CPL_P", "BONDECOMMANDE_CLIENT_CPL_V", "BONDECOMMANDE_CLIENT_CPL_A"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Pr&eacute;par&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=vente/bondecommande/bondecommande-saisie.jsp&currentMenu=MNDN000000001071\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un bon de commande</a>"
    );
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 noppadding">
                <div class="col-md-2 noppadding">
                    <label for="etat" class="input-label" >&Eacute;tat :</label>
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
