package com.skilldistillery.exercises.data;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public final class DemoPersistence {
  private DemoPersistence() {
  }

  public static EntityManagerFactory create(String unitName) {
    Map<String, String> properties = new HashMap<>();
    putEnvironment(properties, "javax.persistence.jdbc.url", "SPRING_DATASOURCE_URL");
    putEnvironment(properties, "javax.persistence.jdbc.user", "SPRING_DATASOURCE_USERNAME");
    putEnvironment(properties, "javax.persistence.jdbc.password", "SPRING_DATASOURCE_PASSWORD");
    return Persistence.createEntityManagerFactory(unitName, properties);
  }

  private static void putEnvironment(Map<String, String> properties, String property, String environmentName) {
    String value = System.getenv(environmentName);
    if (value != null && !value.trim().isEmpty()) {
      properties.put(property, value);
    }
  }
}
