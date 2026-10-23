<%@ page import="rapport.utilitaire.ExportJarClassesToJson" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    try {
        ExportJarClassesToJson exportJarClassesToJson = new ExportJarClassesToJson();
        String map = exportJarClassesToJson.castJsonToString();
        String[] classNames = exportJarClassesToJson.getClassNames();
%>
<div class="content-wrapper">
    <div class="patient-form-container">
        <div class="form-header">
            <h1>Configuration du contenus</h1>
        </div>

        <form action="module.jsp?but=apresTarif.jsp" method="post">
            <div class="form-content">
                <div class="form-row">
                    <div class="form-group-left">
                        <label>Titre</label>
                        <input type="text" class="form-input-c" id="titreInput" name="titre"/>
                    </div>
                    <div class="form-group-right">
                        <label>Vue</label>
                        <input type="text" class="form-input-c" id="vueInput" name="vue"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group-left">
                        <label>Paragraphe</label>
                        <input type="text" class="form-input-c" id="paragrapheInput" name="paragraphe"/>
                    </div>
                    <div class="form-group-right">
                        <label>LibEntete</label>
                        <input id="libEnteteInput"
                               type="text"
                               class="form-input-c"
                               placeholder="Attributs..."
                               list="libEnteteList">
                        <datalist id="libEnteteList"></datalist>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group-left">
                        <label>Mapping</label>
                        <input id="classeInput"
                               type="text"
                               class="form-input-c"
                               placeholder="Entrer le nom de la classe..."
                               list="classesList"
                               onchange="showAttributes();"
                               name="mapping">
                        <datalist id="classesList">
                            <% for(int i=0; i<classNames.length; i++){ %>
                            <option value="<%= classNames[i] %>"></option>
                            <% } %>
                        </datalist>
                    </div>
                    <div class="form-group-right">
                        <label>Colonne Somme</label>
                        <input id="colsommeInput"
                               type="text"
                               class="form-input-c"
                               placeholder="Attributs..."
                               list="colDate">
                        <datalist id="colsomme"></datalist>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group-left">
                        <!-- Espace vide pour maintenir l'alignement -->
                    </div>
                    <div class="form-group-right">
                        <label>Colonne Date</label>
                        <input id="colDateInput"
                               type="text"
                               class="form-input-c"
                               placeholder="Attributs..."
                               list="colDate">
                        <datalist id="colDate"></datalist>
                    </div>
                </div>
            </div>
            <input name="acte" type="hidden" id="acte" value="insert">
            <input name="bute" type="hidden" id="bute" value="rapport/configuration/cr/config-contenus.jsp">
            <input name="classe" type="hidden" id="classe" value="rapport.mapping.CRContent">

            <div class="form-footer">
                <button type="button" class="btn-reinitialiser">Réinitialiser</button>
                <button type="submit" class="btn-enregistrer">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<style>
    .patient-form-container {
        background-color: #f5f5f5;
        min-height: 100vh;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    .form-header {
        /*background-color: #ffffff;*/
        padding: 20px 0;
        text-align: center;
        margin-bottom: 0;
    }

    .form-header h2 {
        color: #8B7D8B;
        font-size: 28px;
        font-weight: 400;
        margin: 0;
    }

    .form-content {
        background-color: #ffffff;
        padding: 40px 60px;
        max-width: 1200px;
        margin: 0 auto;
    }

    .form-row {
        display: flex;
        margin-bottom: 25px;
        gap: 60px;
    }

    .form-group-left,
    .form-group-right {
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    .form-group-left label,
    .form-group-right label {
        color: #8B7D8B;
        font-size: 14px;
        font-weight: 400;
        margin-bottom: 8px;
        display: block;
    }

    .form-input-c {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #d1d1d1;
        border-radius: 4px;
        font-size: 14px;
        color: #333;
        background-color: #ffffff;
        box-sizing: border-box;
    }

    .form-input-c:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
    }

    .form-input-c::placeholder {
        color: #999;
        font-style: normal;
    }

    .form-footer {
        background-color: #ffffff;
        padding: 30px 60px;
        text-align: right;
        max-width: 1200px;
        margin: 0 auto;
    }

    .btn-reinitialiser,
    .btn-enregistrer {
        padding: 10px 25px;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 400;
        cursor: pointer;
        margin-left: 10px;
        min-width: 120px;
    }

    .btn-reinitialiser {
        background-color: #dc3545;
        color: white;
    }

    .btn-reinitialiser:hover {
        background-color: #c82333;
    }

    .btn-enregistrer {
        background-color: #28a745;
        color: white;
    }

    .btn-enregistrer:hover {
        background-color: #218838;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .form-content,
        .form-footer {
            padding: 30px 20px;
        }

        .form-row {
            flex-direction: column;
            gap: 20px;
        }

        .form-footer {
            text-align: center;
        }

        .btn-reinitialiser,
        .btn-enregistrer {
            display: block;
            width: 100%;
            margin: 5px 0;
        }
    }
</style>

<script>
    <%= map %>

    function showAttributes() {
        const selectedClass = document.getElementById("classeInput").value;
        const libEnteteList = document.getElementById("libEnteteList");
        const colSomme = document.getElementById("colsomme");
        const colDate = document.getElementById("colDate");

        console.log('Selectionner: ', classesMap[selectedClass]);

        libEnteteList.innerHTML = "";
        colSomme.innerHTML = "";
        colDate.innerHTML = "";

        if (classesMap[selectedClass]) {
            classesMap[selectedClass].forEach(attr => {
                const option1 = document.createElement("option");
                option1.value = attr;
                libEnteteList.appendChild(option1);

                const option2 = document.createElement("option");
                option2.value = attr;
                colSomme.appendChild(option2);

                const option3 = document.createElement("option");
                option3.value = attr;
                colDate.appendChild(option3);
            });
        }
    }
</script>

<%
    } catch (Exception e) {
        out.println("<script>alert('Erreur lors de la lecture du JSON: " + e.getMessage() + "');</script>");
    }
%>