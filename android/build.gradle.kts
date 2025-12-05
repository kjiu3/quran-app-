allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val androidCallback = { extension: com.android.build.gradle.BaseExtension ->
                extension.ndkVersion = "26.1.10909125"
            }
            // Use reflection or dynamic typing if type is not available in root sciprt context easily, 
            // but BaseExtension is standard for AGP. 
            // However, to be safe in KTS root script without complex imports:
            val android = project.extensions.getByName("android")
            if (android is com.android.build.gradle.BaseExtension) {
                android.ndkVersion = "26.1.10909125"
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
