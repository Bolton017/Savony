

<%@page import="caisse.MvtCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    MvtCaisseCpl t = new MvtCaisseCpl();
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    String listeCrt[] = {"id", "idCaisseLib", "designation", "daty", "tiers"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "daty","designation", "tiers","idCaisseLib" ,"credit","debit", "heure","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des mouvements de caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/mvt/mvtCaisse-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Ref.");
    pr.getFormu().getChamp("idCaisseLib").setLibelle("Tr&eacute;sorerie");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    String[] colSomme = {"credit","debit"};
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/mvt/mvtCaisse-modif.jsp");
    String classe = "caisse.MvtCaisse";
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=caisse/mvt/mvtCaisse-liste.jsp&classe=" + classe +"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=caisse/mvt/apres-Dupliquer.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien

    String lienTableau[] = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref.", "d&eacute;signation","date", "Tiers","Tr&eacute;sorerie" , "Entr&eacute;e de tr&eacute;sorerie","Sortie de tr&eacute;sorerie", "Heure","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Cr&eacute;&eacute;(s)","&Agrave; Comptabliser","Valid&eacute;(s)","Annul&eacute;(s)"};
    String[] etatPasse = {"","_cree","_cptbl","_valider2","_annule"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/mvt/mvtCaisse-saisie-entree.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie mouvement d'entr&eacute;e</a>"+
    "<a class=\"btn btn-primary pull-right btn-small mx-2\" href=\"module.jsp?but=caisse/mvt/mvtCaisse-saisie-sortie.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie mouvement de sortie</a>"
    );
    String[] enteteRecap = {"","Nombres","Somme des Entr&eacute;es de Tr&eacute;sorerie","Somme des Sorties de Tr&eacute;sorerie"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

%>
<script>
    function changerEtat(){
        document.formRecherche.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="formRecherche" id="formRecherche">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        <div class="row col-md-12 nopadding">
            <div class="col-md-4 nopadding">
                <label for="etat" class="input-label">&Eacute;tat</label>
                <select name="etat" id="etat" class="form-control" onchange="changerEtat()">
                    <%
                        for(int i=0; i<etatAffiche.length; i++){
                            String selected = "";
                            if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase(etatPasse[i])==0){
                                selected = "selected";
                            }
                    %>
                    <option value="<%=etatPasse[i]%>" <%=selected%>><%=etatAffiche[i]%></option>
                    <%
                        }
                    %>
                </select>
            </div>
        </div>
        </form>
        <div class="row">
            <div class="col-md-12">
        <%
            out.println(pr.getTableauRecap().getHtml());%>
            </div>
        </div>
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



