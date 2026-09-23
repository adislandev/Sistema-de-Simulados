import type { ButtonHTMLAttributes, ReactNode } from "react";

type ButtonVariant = "primary" | "secondary" | "success" | "danger" | "option";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  fullWidth?: boolean;
  selected?: boolean;
  children: ReactNode;
}

const BASE =
  "inline-flex items-center justify-center gap-2 min-h-11 px-5 rounded-chunky font-semibold text-base transition-all duration-100 disabled:opacity-55 disabled:pointer-events-none disabled:shadow-none disabled:translate-y-0";

const BOUNCY = "active:translate-y-1 active:shadow-none";

const VARIANTS: Record<Exclude<ButtonVariant, "option">, string> = {
  primary: `bg-primary-500 text-white shadow-[0_4px_0_0_var(--color-primary-700)] hover:bg-primary-600 ${BOUNCY}`,
  success: `bg-success-500 text-white shadow-[0_4px_0_0_var(--color-success-700)] hover:brightness-95 ${BOUNCY}`,
  danger: `bg-danger-500 text-white shadow-[0_4px_0_0_var(--color-danger-700)] hover:brightness-95 ${BOUNCY}`,
  secondary: "bg-transparent text-primary-600 border border-primary-100 hover:bg-primary-50",
};

function classesOption(selected: boolean) {
  return selected
    ? "bg-primary-50 text-ink border-2 border-primary-500 justify-start text-left"
    : "bg-surface text-ink border-2 border-primary-100 justify-start text-left hover:border-primary-400";
}

export default function Button({
  variant = "primary",
  fullWidth = false,
  selected = false,
  className = "",
  children,
  ...props
}: ButtonProps) {
  const variantClasses = variant === "option" ? classesOption(selected) : VARIANTS[variant];
  return (
    <button
      className={`${BASE} ${variantClasses} ${fullWidth ? "w-full" : ""} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
}
