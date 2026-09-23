import type { ReactNode } from "react";

interface PageLayoutProps {
  wide?: boolean;
  children: ReactNode;
}

export default function PageLayout({ wide = false, children }: PageLayoutProps) {
  return (
    <div className="min-h-full flex flex-col items-center px-4 pt-6 pb-12">
      <div className={`w-full ${wide ? "max-w-[1080px]" : "max-w-[640px]"}`}>{children}</div>
    </div>
  );
}
