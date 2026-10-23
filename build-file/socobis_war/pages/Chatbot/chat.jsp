<button id="toggleChat">Aide</button>
<div class="chat">
    <div class="chat-title">
        <h1>Async</h1>
        <h2>Async</h2>
        <figure class="avatar">
            <img src="${pageContext.request.contextPath}/assets/img/logo_A.png" />
        </figure>
    </div>

    <div class="messages">
        <div class="messages-content"></div>
    </div>
    <br>
    <span id="fileName" style="font-size: 12px; color: #666;"></span>
    <div class="message-box">

        <label for="fileInput" class="fa fa-paperclip" style="cursor: pointer; margin-right: 10px;"></label>
        <input type="file" id="fileInput" style="display: none;" />
        <textarea type="text" class="message-input" placeholder="Type message..."></textarea>
        <button id="voiceBtn" class="message-submit fa fa-microphone"></button>
        <button type="submit" class="message-submit fa fa-arrow-up"></button>
    </div>
</div>

<div class="bg"></div>


<script>
    document.getElementById("fileInput").addEventListener("change", function () {
        const file = this.files[0];
        const fileNameSpan = document.getElementById("fileName");

        if (file) {
            fileNameSpan.textContent = file.name;
        } else {
            fileNameSpan.textContent = "";
        }
    });

    // Get the toggle button and the chat modal element
    const toggleButton = document.getElementById('toggleChat');
    const chatModal = document.querySelector('.chat');

    // Add a click event listener to the toggle button
    toggleButton.addEventListener('click', function() {
        // Check the current display style and toggle it
        if (chatModal.style.display === 'none' || chatModal.style.display === '') {
            chatModal.style.display = 'flex';
        } else {
            chatModal.style.display = 'none';
        }
    });
    // Voice Recognition Setup
    const voiceButton = document.getElementById('voiceBtn');
    const messageInput = document.querySelector('.message-input');

    // Check if the browser supports Speech Recognition API
    if ('webkitSpeechRecognition' in window) {
        const recognition = new webkitSpeechRecognition();
        recognition.continuous = false;
        recognition.interimResults = false;
        recognition.lang = 'fr-FR'; // You can change this to the desired language

        recognition.onstart = function() {
            console.log('Voice recognition started...');
        };

        recognition.onresult = function(event) {
            const transcript = event.results[0][0].transcript;
            messageInput.value = transcript; // Fill the textarea with the transcribed text

            //submit
            document.querySelector('.message-submit').click();
        };

        recognition.onerror = function(event) {
            console.error('Error occurred in speech recognition: ', event.error);
        };

        // Start voice recognition when user clicks the microphone button
        voiceButton.addEventListener('click', function() {
            recognition.start();
        });
    } else {
        console.log("Speech Recognition API is not supported in this browser.");
    }
</script>
<script>
    const bgOverlay = document.querySelector('.bg');
    bgOverlay.addEventListener('click', function() {
        chatModal.style.display = 'none';
    });
</script>