defmodule Calc.CalcController do
  use Phoenix.Controller

  plug :action

  defp fetch(str) do
    case :ets.lookup(:mem, str) do
      [{str, value}] ->
        value
      [] ->
        :notfound
    end
  end

  defp parse(num) when is_float(num) do
    num
  end

  defp parse(num) when is_integer(num) do
    num * 1.0
  end
    
  defp parse(str) when is_binary(str) do
    case Float.parse str do
      {n, ""} ->
        n
      {_, _} ->
        :error
      :error ->
        fetch(str)
    end
  end

  defp evaluate(left_n, op, right_n) do
    case op do
      "add" ->
        {left_n + right_n, ""}
      "sub" ->
        {left_n - right_n, ""}
      "mul" ->
        {left_n * right_n, ""}
      "div" ->
        {left_n / right_n, ""}
      "pow" ->
        {:math.pow(left_n, right_n), ""}
      _ ->
        {"error", "operator invalid"}
    end
  end

  defp evaluate(op, right_n) do
    case op do
      "exp" ->
        {:math.exp(right_n), ""}
      "neg" ->
        {-right_n, ""}
      _ ->
        {"error", "operator invalid"}
    end
  end

  def unary(conn, %{"op" => op, "right" => right}) do
    right_n = parse(right)

    {result, message} = cond do
      right_n == :error ->
        {"error", "operand invalid"}
      right_n == :notfound ->
        {"error", "operand slot not found"}
      true ->
        ConCache.get_or_store(:calc_cache, {op, right_n}, fn() ->
          evaluate(op, right_n)
        end)
    end

    json conn, %{result: result, message: message}
  end

  def binary(conn, %{"left" => left, "op" => op, "right" => right}) do
    left_n = parse(left)
    right_n = parse(right)

    {result, message} = cond do
      left_n == :error ->
        {"error", "left operand invalid"}
      left_n == :notfound ->
        {"error", "left operand slot not found"}
      right_n == :error ->
        {"error", "right operand invalid"}
      right_n == :notfound ->
        {"error", "right operand slot not found"}
      true ->
        ConCache.get_or_store(:calc_cache, {left_n, op, right_n}, fn() ->
          evaluate(left_n, op, right_n)
        end)
    end

    json conn, %{result: result, message: message}
  end

  def save(conn, %{"slot" => slot, "value" => value}) do
    {result, message} = case parse(value) do
      :error ->
        {"error", "invalid value"}
      :notfound ->
        {"error", "slot not found"}
      num ->
        :ets.insert :mem, {slot, num}
        {num, ""}
    end

    json conn, %{result: result, message: message}
  end

  def load(conn, %{"slot" => slot}) do
    {result, message} = case fetch(slot) do
      :error ->
        {"error", "slot not found"}
      value ->
        {value, ""}
    end

    json conn, %{result: result, message: message}
  end
end
