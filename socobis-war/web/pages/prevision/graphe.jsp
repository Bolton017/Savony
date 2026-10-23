<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Graphique avec clic droit</title>
    <!-- Inclusion de Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclusion de Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Style du menu contextuel */
        #contextMenu {
            position: absolute;
            background: white;
            border: 1px solid #ccc;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: none;
            z-index: 1000;
        }
        #contextMenu ul {
            list-style-type: none;
            padding: 10px;
            margin: 0;
        }
        #contextMenu ul li {
            padding: 8px 15px;
            cursor: pointer;
        }
        #contextMenu ul li:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <h2 class="text-center">Graphique des ventes par mois<%=4*40%></h2>
    <!-- Conteneur pour afficher le graphique -->
    <div class="row justify-content-center">
        <div class="col-md-8">
            <canvas id="myChart"></canvas>
        </div>
    </div>

    <!-- Menu contextuel -->
    <div id="contextMenu">
        <ul>
            <li id="menuOption1">Option 1</li>
            <li id="menuOption2">Option 2</li>
        </ul>
    </div>
</div>

<script>
    // Données fournies
    const data = {
        Janvier: 50,
        Fevrier: 100,
        Mars: 80,
        Avril: 120,
        Mai: 90,
        Juin: 110
    };

    const dataAchat = {
        Janvier: 30,
        Fevrier: 50,
        Mars: 40,
        Avril: 60,
        Mai: 40,
        Juin: 50
    };
    // Extraire les mois et les valeurs à partir des données
    //const months = Object.keys(data);
    const months=['janvier','fev','mars','avr','mai','jiona'];
    const values = Object.values(data);
    const valuesAchat = Object.values(dataAchat);

    // Créer le graphique avec Chart.js
    const ctx = document.getElementById('myChart').getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'bar', // Type de graphique (barres)
        data: {
            labels: months, // Mois en abscisse
            datasets: [{
                label: 'Ventes',
                data: values, // Valeurs en ordonnée
                backgroundColor: 'rgba(75, 192, 192, 0.2)', // Couleur de fond des barres
                borderColor: 'rgba(75, 192, 192, 1)', // Couleur des bordures des barres
                borderWidth: 1
            },{
                label: 'Achat',
                data: valuesAchat, // Valeurs en ordonnée
                backgroundColor: 'rgba(100, 12, 192, 0.2)', // Couleur de fond des barres
                borderColor: 'rgba(100, 11, 192, 1)', // Couleur des bordures des barres
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // Récupérer l'élément de graphique
    const chartCanvas = document.getElementById('myChart');

    // Menu contextuel
    const contextMenu = document.getElementById('contextMenu');

    // Fonction pour afficher le menu contextuel
    chartCanvas.addEventListener('contextmenu', function(event) {
        event.preventDefault(); // Empêcher le menu contextuel par défaut du navigateur

        // Positionner le menu à la position du clic droit
        contextMenu.style.left = event.pageX + 'px';
        contextMenu.style.top = event.pageY + 'px';

        // Afficher le menu
        contextMenu.style.display = 'block';
    });
    // Cacher le menu contextuel lorsqu'on clique ailleurs
    document.addEventListener('click', function() {
        contextMenu.style.display = 'none';
    });

    // Actions du menu contextuel
    document.getElementById('menuOption1').addEventListener('click', function() {
        alert('Option 1 cliquée');
    });
    document.getElementById('menuOption2').addEventListener('click', function() {
        alert('Option 2 cliquée');
    });
</script>

<!-- Inclusion de Bootstrap JS (optionnel) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>