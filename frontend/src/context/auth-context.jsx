import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";

import { getData, postData } from "@/lib/api";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const refreshUser = useCallback(async () => {
    try {
      const data = await getData("/auth/me");
      setUser(data.user);
      return data.user;
    } catch (error) {
      setUser(null);
      return null;
    }
  }, []);

  useEffect(() => {
    if (window.location.hash?.includes("session_id=")) {
      setLoading(false);
      return;
    }

    let active = true;
    (async () => {
      const currentUser = await refreshUser();
      if (active || currentUser === null) {
        setLoading(false);
      }
    })();

    return () => {
      active = false;
    };
  }, [refreshUser]);

  const register = useCallback(async (payload) => {
    const data = await postData("/auth/register", payload);
    setUser(data.user);
    return data.user;
  }, []);

  const login = useCallback(async (payload) => {
    const data = await postData("/auth/login", payload);
    setUser(data.user);
    return data.user;
  }, []);

  const logout = useCallback(async () => {
    try {
      await postData("/auth/logout");
    } finally {
      setUser(null);
    }
  }, []);

  const handleGoogleSession = useCallback(async (sessionId) => {
    const data = await postData("/auth/google/session", { session_id: sessionId });
    setUser(data.user);
    return data.user;
  }, []);

  const value = useMemo(
    () => ({
      user,
      setUser,
      loading,
      setLoading,
      refreshUser,
      register,
      login,
      logout,
      handleGoogleSession,
    }),
    [handleGoogleSession, loading, login, logout, refreshUser, register, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const value = useContext(AuthContext);
  if (!value) {
    throw new Error("useAuth must be used inside AuthProvider");
  }
  return value;
}
