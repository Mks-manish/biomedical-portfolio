// Toggle experience details
function toggleExperience(id) {
    const details = document.getElementById(id + '-details');
    const header = event.currentTarget;
    
    // Close all other open details
    document.querySelectorAll('.exp-details.active').forEach(item => {
        if (item.id !== id + '-details') {
            item.classList.remove('active');
            item.previousElementSibling.previousElementSibling.classList.remove('active');
        }
    });
    
    // Toggle current
    details.classList.toggle('active');
    header.classList.toggle('active');
}

// Open resources in new tab
function openResource(filePath) {
    window.open(filePath, '_blank');
}

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Navbar background on scroll
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 100) {
            navbar.style.background = 'rgba(255, 255, 255, 0.95)';
            navbar.style.backdropFilter = 'blur(10px)';
        } else {
            navbar.style.background = '#fff';
            navbar.style.backdropFilter = 'none';
        }
    });

    // Initialize first experience as open
    toggleExperience('case-western');
});