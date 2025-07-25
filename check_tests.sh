#\!/bin/bash
echo "Lancement des tests Flutter..."
flutter test 2>&1  < /dev/null |  tail -20 | grep -E "All tests passed!|[0-9]+ test"
