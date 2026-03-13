import React from "react";
import ReactDOM from "react-dom/client";
import { ThemeProvider } from "next-themes";

import { Toaster } from "@/components/ui/sonner";
import "@/index.css";
import App from "@/App";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <ThemeProvider attribute="class" defaultTheme="dark" enableSystem={false}>
      <App />
      <Toaster position="top-right" richColors />
    </ThemeProvider>
  </React.StrictMode>,
);
