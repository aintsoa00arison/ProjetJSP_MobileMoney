<nav class="navbar navbar-expand-lg sticky-top custom-navbar shadow">
    <div class="container position-relative">
        
        <a class="navbar-brand logo-wrapper" href="index.jsp">
            <img src="assets/img/NovaCash.png" alt="NovaCash Logo" class="nav-logo-giant">
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="filter: invert(1) sepia(1) saturate(5) hue-rotate(120deg);"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto" id="nav-links-container">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">Accueil</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="liste_clients.jsp">Clients</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="transaction.jsp">Flux</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="frais.jsp">Tarifs</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="recette.jsp">Revenus</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<style>
    /* 1. La Navbar garde une taille fixe et élégante */
    .custom-navbar {
        background-color: var(--main-dark);
        border-bottom: 3px solid var(--accent-mint);
        height: 70px; /* Force la hauteur de la barre */
        z-index: 1000;
    }

    /* 2. Le conteneur du logo en position absolue */
    .logo-wrapper {
        position: absolute;
        top: 40%;
        transform: translateY(-40%); /* Centre verticalement par rapport à la barre */
        left: 15px;
        z-index: 1100; /* Passe par-dessus la navbar et le contenu de la page */
    }

    /* 3. Le logo géant */
    .nav-logo-giant {
        height: 150px; /* Taille souhaitée */
        width: auto;
        display: block;
        filter: drop-shadow(0 8px 15px rgba(0,0,0,0.4)); /* Ombre portée pour le détachement */
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .nav-logo-giant:hover {
        transform: scale(1.05);
        filter: drop-shadow(0 12px 20px rgba(0,0,0,0.5));
    }

    /* Style des liens */
    .nav-link {
        color: rgba(255,255,255,0.7) !important;
        font-weight: 500;
        margin-left: 25px;
        transition: all 0.3s ease;
        border-bottom: 2px solid transparent;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    /* État actif géré dynamiquement */
    .nav-link.active {
        color: var(--accent-mint) !important;
        border-bottom: 2px solid var(--accent-mint);
    }

    /* Responsive : on réduit un peu sur mobile pour ne pas tout cacher */
    @media (max-width: 991px) {
        .custom-navbar {
            height: auto;
            min-height: 70px;
        }
        .logo-wrapper {
            position: relative;
            top: 0;
            transform: none;
        }
        .nav-logo-giant {
            height: 80px;
            margin: 10px 0;
        }
    }
</style>

<script>
    /**
     * Script pour détecter automatiquement la page active 
     * et l'appliquer au bon lien de la navbar
     */
    document.addEventListener("DOMContentLoaded", function() {
        const path = window.location.pathname;
        const page = path.split("/").pop();
        
        const links = document.querySelectorAll('#nav-links-container .nav-link');
        
        links.forEach(link => {
            const href = link.getAttribute('href');
            // Gère l'index ou le chemin vide
            if (page === href || (page === "" && href === "index.jsp")) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    });
</script>