#!/bin/bash

echo "🔍 Validation de la configuration Android pour Ojyx"
echo "=================================================="

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Compteurs
PASSED=0
FAILED=0

# Fonction de test
test_step() {
    local test_name="$1"
    local command="$2"
    
    echo -n "Checking $test_name... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        ((FAILED++))
        return 1
    fi
}

# Fonction de test avec output
test_step_with_output() {
    local test_name="$1"
    local command="$2"
    
    echo "Checking $test_name..."
    
    if eval "$command"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        ((FAILED++))
        return 1
    fi
}

echo "🔧 Vérifications de base..."

# Test 1: Flutter doctor
test_step_with_output "Flutter doctor" "flutter doctor"

# Test 2: Fichiers de configuration présents
test_step "Configuration Gradle wrapper" "test -f android/gradle/wrapper/gradle-wrapper.properties"
test_step "Configuration build.gradle.kts app" "test -f android/app/build.gradle.kts"
test_step "Configuration proguard-rules" "test -f android/app/proguard-rules.pro"
test_step "AndroidManifest.xml" "test -f android/app/src/main/AndroidManifest.xml"
test_step "Network security config" "test -f android/app/src/main/res/xml/network_security_config.xml"

# Test 3: Contenu des fichiers de configuration
echo -e "\n🔍 Vérifications du contenu..."

test_step "Gradle version >= 8.5" "grep -q 'gradle-8\.' android/gradle/wrapper/gradle-wrapper.properties"
test_step "Namespace configuré" "grep -q 'namespace = \"com.example.ojyx\"' android/app/build.gradle.kts"
test_step "MultiDex activé" "grep -q 'multiDexEnabled = true' android/app/build.gradle.kts"
test_step "Java 17 configuré" "grep -q 'JavaVersion.VERSION_17' android/app/build.gradle.kts"
test_step "Permission Internet" "grep -q 'android.permission.INTERNET' android/app/src/main/AndroidManifest.xml"
test_step "AndroidX activé" "grep -q 'android.useAndroidX=true' android/gradle.properties"

# Test 4: Tâches Gradle
echo -e "\n🔨 Vérifications Gradle..."

cd android || exit 1
test_step "Gradle tasks accessibles" "./gradlew tasks --quiet"
test_step "Résolution des dépendances" "./gradlew dependencies --quiet --configuration debugRuntimeClasspath"
cd .. || exit 1

# Test 5: Builds de test (si SDK Android disponible)
echo -e "\n🏗️ Tests de build..."

if command -v flutter >/dev/null 2>&1; then
    if flutter doctor | grep -q "Android toolchain.*✓"; then
        echo "SDK Android détecté, test des builds..."
        test_step_with_output "Build debug APK" "flutter build apk --debug"
        
        if [ $? -eq 0 ]; then
            test_step "APK debug généré" "test -f build/app/outputs/flutter-apk/app-debug.apk"
            
            # Vérifier la taille de l'APK
            if [ -f build/app/outputs/flutter-apk/app-debug.apk ]; then
                APK_SIZE=$(stat -f%z build/app/outputs/flutter-apk/app-debug.apk 2>/dev/null || stat -c%s build/app/outputs/flutter-apk/app-debug.apk 2>/dev/null)
                echo "📦 Taille de l'APK debug: $(echo $APK_SIZE | awk '{print int($1/1024/1024)} MB')"
            fi
        fi
    else
        echo -e "${YELLOW}⚠️ SDK Android non configuré, skip des tests de build${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ Flutter non disponible, skip des tests de build${NC}"
fi

# Résultats finaux
echo -e "\n📊 Résultats de validation"
echo "========================="
echo -e "Tests réussis: ${GREEN}$PASSED${NC}"
echo -e "Tests échoués: ${RED}$FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 Configuration Android validée avec succès!${NC}"
    echo "✅ Prêt pour le développement Android"
    exit 0
else
    echo -e "\n${RED}⚠️ $FAILED test(s) ont échoué${NC}"
    echo "❌ Consulter ANDROID_BUILD.md pour la résolution des problèmes"
    exit 1
fi