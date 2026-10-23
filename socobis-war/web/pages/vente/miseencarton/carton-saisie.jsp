<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="fabrication.FabricationFille" %>
<%@ page import="fabrication.OfFilleCpl" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="vente.*" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%
    try{
        
        UserEJB u = null;
        String idof = null;
        OfFilleCpl[] ofFille = null;
        u = (UserEJB) session.getValue("u");
        Carton mere = new Carton();
        CartonFille fille = new CartonFille();
        fille.setNomTable("CartonFille");
        String idBC = request.getParameter("idbc");
        String ids = request.getParameter("ids");
        
        BonDeCommande comm = new BonDeCommande();
        comm.setId(idBC);
        CartonFille[] fabfille = null;

        if(ids!= null && ids!=""){
            String[] idbcf = ids.split(";");
            fabfille = comm.getCartonFille(idbcf);
            System.out.println("JSP was successfully forwarded to!");
        }

        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        CartonFille[] fillesIA = (CartonFille[])session.getAttribute("fillesIA");
        pi.setLien((String) session.getValue("lien"));

        if(idBC != "" && idBC != null){
            pi.getFormu().getChamp("idBc").setDefaut(idBC);
            if(fabfille!=null && fabfille.length > 0){
                pi.setDefautFille(fabfille);
                pi.getFormu().getChamp("remarque").setDefaut("Mise en Carton du BC  "+idBC);
            }
        }
        
        pi.getFormu().getChamp("dateCreation").setLibelle("Date de Creation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");  
        pi.getFormu().getChamp("etat").setVisible(false);        
        pi.getFormu().getChamp("idBC").setLibelle("Id Bon de Commande");
        pi.getFormu().getChamp("idBL").setAutre("readonly");

        pi.getFormufle().getChamp("idIngredient_0").setLibelle("Composants");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idBcFille_0").setLibelle("BC Fille");

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),"readonly");

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredient").getListeChamp(), "produits.IngredientsLib", "id", "as_ingredients_lib", "","");
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "vente.Carton";
        String classeFille = "vente.CartonFille";
        String butApresPost = "vente/miseencarton/carton-fiche.jsp";
        String colonneMere = "idmere";

        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Saisie Mise en Carton</h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>

</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
<script>
    window.addEventListener('load', function() {
        let firstLimit = 10;
        for (let i = 0; i < firstLimit; i++) {
            let currentId = 'idIngredient_' + i + 'libelle';
            let input = document.getElementById(currentId);
            input.addEventListener('keydown', function(event) {
                if (event.key === 'Enter') {
                    console.log("ENTER");
                    event.preventDefault();

                    const currentInput = event.target;
                    const currentId = currentInput.id;
                    const nextId = currentId.replace(/\d+/, function(num) {
                        return parseInt(num) + 1;
                    });
                    const nextInput = document.getElementById(nextId);
                    const numMatch = currentId.match(/\d+/);
                    let prevNum = -1;
                    if (numMatch) {
                        prevNum = parseInt(numMatch[0]);
                    }

                    $('#' + currentId).autocomplete({
                        source: function(request, response) {
                            $.ajax({
                                url: "/savonnerie/autocomplete",
                                method: "GET",
                                contentType: "application/x-www-form-urlencoded",
                                dataType: "json",
                                data: {
                                    libelle: request.term,
                                    affiche: null,
                                    valeur: 'id',
                                    nomTable: 'as_ingredients_lib',
                                    classe: 'produits.IngredientsLib',
                                    champRetour: 'id',
                                    colFiltre: 'id',
                                    useMotcle: true
                                },
                                success: function(data) {
                                    console.log(data);
                                    response($.map(data.valeure, function(item) {
                                        return {
                                            label: item.id,
                                            value: item.valeur,
                                            retour: item.retour
                                        };
                                    }));
                                }
                            });
                        },

                        response: function(event, ui) {
                            let item = ui.content[0];
                            console.log(ui.content[0]);

                            for (let j = 0; j < firstLimit; j++) {
                                if (j === prevNum) continue;
                                let idExist = $('#idIngredient_' + j).val();
                                if (idExist === item.label) {
                                    let qte = $('#quantite_' + j).val();
                                    let nouvelleQte = parseInt(qte || '0') + 1;
                                    $('#quantite_' + j).val(nouvelleQte);
                                    $('#idIngredient_' + prevNum).val('');
                                    $('#idIngredient_' + prevNum + 'libelle').val('');
                                    $('#quantite_' + prevNum).val('');

                                    return;
                                }
                            }

                            $('#idIngredient_' + prevNum).val(item.label);
                            $('#idIngredient_' + prevNum + 'libelle').val(item.value);
                            $('#quantite_' + prevNum).val(1);
                            console.log("vaovao");

                            let checkbox = document.getElementById('checkbox' + prevNum);
                            if (checkbox) checkbox.checked = true;

                            if (nextInput) {
                                nextInput.focus();
                            }
                        }
                    });

                    $('#' + currentId).autocomplete('enable').autocomplete('search', event.target.value);
                }
            });
        }
    });
</script>

