<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>


<% try{
    BonDeCommandeCpl bdc = new BonDeCommandeCpl();
    String nomTable = "BondecommandeApreparer";
        if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("etat");
        }
       bdc.setNomTable(nomTable);
    String listeCrt[] = {"id","remarque","designation","reference","modepaiement","daty","idclientlib","idMagasinLib","commerciallib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","idclientlib","designation","reference","commerciallib","modepaiementlib","remarque","nbfacture","idMagasinLib","etatlib"};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de pr&eacute;paration");

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
    pr.setApres("vente/bondecommande/bondepreparation.jsp");

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    pr.getFormu().getChamp("commerciallib").setLibelle("Commercial");
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


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    lienTab.put("Valider",pr.getLien() + "?&classe=vente.BonDeCommande&but=apresTarif.jsp&bute=vente/bondecommande/bondepreparation.jsp&acte=valider"+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("vente/bondecommande/inc/proforma-liste-detail.jsp&id=");
    String libEnteteAffiche[] = {"Id","Date","Client","D&eacute;signation","r&eacute;f&eacute;rence","Commercial","Mode de paiement","Remarque","Nombre de Facture","Magasin","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatVal = {"BondecommandeApreparer","BondecommandeApreparer_c", "BondecommandeApreparer_v", "BondecommandeApreparer_a"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
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
