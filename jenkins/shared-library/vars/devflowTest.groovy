def call() {
    stage('Install Dependencies') {
        sh 'python3 -m pip install -r requirements.txt'
    }

    stage('Run Tests') {
        sh 'python3 -m pytest -q'
    }
}
